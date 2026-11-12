/**
 * OpenCode Go key switcher.
 *
 * Keys live in `~/.pi/agent/opencode-go-keys.json`:
 *
 *   { "default": "work", "keys": { "personal": "sk-...", "work": "sk-..." } }
 *
 * Which key a session uses, first match wins:
 *
 *   1. `/key <label>` picked for this session (survives resume)
 *   2. the label the parent session passed down as PI_OPENCODE_GO_KEY_LABEL, so
 *      subagents follow the key selected where they were started
 *   3. the file's `default`, then `work`, then the first key in the file
 *
 * `personal` is used only when it is picked by hand or set as the default.
 *
 * Commands:
 *   /key                  show the keys and pick one for this session
 *   /key <label>          use <label> for this session (survives resume)
 *   /key default <label>  set the default used when nothing is picked
 *
 * A key file still holding `primary`/`secondary` is renamed to
 * `personal`/`work` the first time this extension reads it.
 *
 * Requests in this process always use the active key. Subagents load this
 * extension in their own process, so they read the same key file, but they also
 * inherit the active label and follow the parent's pick instead of resolving
 * from their own working directory. A child that cannot read the key file
 * (pi-sandbox hides it) keeps the inherited OPENCODE_API_KEY, which Pi's
 * built-in order would lose to a stored `auth.json` credential: run
 * `/logout opencode-go` to drop that credential.
 *
 * If the key file is missing, the provider falls back to Pi's built-in
 * credential resolution (stored credential, then OPENCODE_API_KEY).
 */

import { chmodSync, readFileSync, renameSync, statSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { builtinProviders } from "@earendil-works/pi-ai/providers/all";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const AGENT_DIR = process.env.PI_CODING_AGENT_DIR ?? join(homedir(), ".pi", "agent");
const KEYS_PATH = join(AGENT_DIR, "opencode-go-keys.json");
const AUTH_PATH = join(AGENT_DIR, "auth.json");
/** Preferred label when the file names no usable default. */
const DEFAULT_LABEL = "work";
/** Set by this extension for subagent processes, which inherit the parent's pick. */
const INHERIT_LABEL_ENV = "PI_OPENCODE_GO_KEY_LABEL";
const STATUS_KEY = "ocg-key";
const ENTRY_TYPE = "opencode-go-key";

/** Labels an older key file used, and what they are called now. */
const RENAMED_LABELS: Record<string, string> = { primary: "personal", secondary: "work" };

interface KeyFile {
	/** The file as parsed, so writes keep fields this extension does not know about. */
	body: Record<string, unknown>;
	default: string;
	keys: Record<string, string>;
}

/** A resolved key and where it came from. */
interface Pick {
	label: string;
	key: string;
	source: string;
}

interface AuthInput {
	ctx: { env(name: string): Promise<string | undefined> };
	credential?: { key?: string; env?: Record<string, string> };
	signal: AbortSignal;
}

let sessionLabel: string | undefined;
let pendingNote: string | undefined;
let cached: { mtimeMs: number; file: KeyFile } | undefined;

function failure(error: unknown): string {
	return error instanceof Error ? error.message : String(error);
}

/** Renames a legacy `primary`/`secondary` pair in place; true when a label moved. */
function renameLabels(body: Record<string, unknown>): boolean {
	const keys = body.keys as Record<string, string>;
	let renamed = false;
	for (const [oldLabel, newLabel] of Object.entries(RENAMED_LABELS)) {
		if (!(oldLabel in keys) || newLabel in keys) continue;
		keys[newLabel] = keys[oldLabel]!;
		delete keys[oldLabel];
		renamed = true;
	}
	if (typeof body.default === "string") {
		const moved = RENAMED_LABELS[body.default];
		if (moved && moved in keys) {
			body.default = moved;
			renamed = true;
		}
	}
	return renamed;
}

/** Replaces the file atomically, so a failed write cannot lose the keys. */
function writeKeyFile(body: Record<string, unknown>): void {
	const tmp = `${KEYS_PATH}.tmp`;
	writeFileSync(tmp, `${JSON.stringify(body, null, 2)}\n`, { mode: 0o600 });
	try {
		chmodSync(tmp, 0o600);
	} catch {
		// Best effort: the containing directories are already private.
	}
	renameSync(tmp, KEYS_PATH);
}

/** undefined when the file does not exist yet; throws when it exists but is unusable. */
function readKeyFile(): KeyFile | undefined {
	let mtimeMs: number;
	try {
		mtimeMs = statSync(KEYS_PATH).mtimeMs;
	} catch {
		cached = undefined;
		return undefined;
	}
	if (cached?.mtimeMs === mtimeMs) return cached.file;

	let parsed: unknown;
	try {
		parsed = JSON.parse(readFileSync(KEYS_PATH, "utf-8"));
	} catch (error) {
		throw new Error(`Cannot read ${KEYS_PATH}: ${failure(error)}`);
	}
	if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
		throw new Error(`${KEYS_PATH} needs a "keys" object holding at least one key.`);
	}
	const body = parsed as Record<string, unknown>;
	const keys = body.keys;
	if (!keys || typeof keys !== "object" || Array.isArray(keys) || Object.keys(keys).length === 0) {
		throw new Error(`${KEYS_PATH} needs a "keys" object holding at least one key.`);
	}
	const labels = keys as Record<string, string>;

	if (renameLabels(body)) {
		const renamed = Object.keys(labels).join(", ");
		try {
			writeKeyFile(body);
			pendingNote = `Renamed the OpenCode Go key labels; ${KEYS_PATH} now uses: ${renamed}.`;
		} catch (error) {
			pendingNote = `Could not rename the labels in ${KEYS_PATH} (${failure(error)}); using ${renamed} for this run.`;
		}
	}
	for (const [label, key] of Object.entries(labels)) {
		if (typeof key !== "string" || key.trim().length === 0) {
			throw new Error(`${KEYS_PATH}: key "${label}" is empty. Paste the OpenCode Go key for "${label}".`);
		}
	}

	const file: KeyFile = {
		body,
		default: typeof body.default === "string" ? body.default : "",
		keys: labels,
	};
	cached = { mtimeMs, file };
	return file;
}

/**
 * Session pick, then the label the parent process passed down, then the file
 * default, then `work`, then the first key.
 */
function activeLabel(file: KeyFile): string {
	if (sessionLabel && file.keys[sessionLabel]) return sessionLabel;
	const inherited = process.env[INHERIT_LABEL_ENV];
	if (inherited && file.keys[inherited]) return inherited;
	for (const label of [file.default, DEFAULT_LABEL]) {
		if (label && file.keys[label]) return label;
	}
	return Object.keys(file.keys)[0]!;
}

/** The parent session's key, handed to subagent processes. */
function inheritedPick(): Pick | undefined {
	const label = process.env[INHERIT_LABEL_ENV];
	const key = process.env.OPENCODE_API_KEY;
	if (!label || !key) return undefined;
	return { label, key, source: `${INHERIT_LABEL_ENV} (inherited: ${label})` };
}

/**
 * The key file decides, except when the process cannot read it: then the
 * inherited variable wins, which Pi's stored-credential-first order would
 * otherwise lose.
 */
function pickKey(): Pick | undefined {
	let file: KeyFile | undefined;
	let readError: unknown;
	try {
		file = readKeyFile();
	} catch (error) {
		readError = error;
	}
	if (file) {
		const label = activeLabel(file);
		return { label, key: file.keys[label]!, source: `${KEYS_PATH} (${label})` };
	}
	const inherited = inheritedPick();
	if (inherited) return inherited;
	if (readError) throw readError;
	return undefined;
}

/** Subagents spawn as separate pi processes and inherit both values. */
function exportForChildren(label: string, key: string): void {
	process.env.OPENCODE_API_KEY = key;
	process.env[INHERIT_LABEL_ENV] = label;
}

function setStatus(ctx: ExtensionContext, label: string | undefined): void {
	ctx.ui.setStatus(STATUS_KEY, label ? `go:${label}` : undefined);
}

/** Reports a rename once, whatever call read the file first. */
function flushNote(ctx: ExtensionContext): void {
	const note = pendingNote;
	pendingNote = undefined;
	if (note) ctx.ui.notify(note, "info");
}

function storedCredentialNote(): string | undefined {
	try {
		const stored = JSON.parse(readFileSync(AUTH_PATH, "utf-8")) as Record<string, unknown>;
		if (stored?.["opencode-go"]) {
			return "auth.json also holds an opencode-go credential, which outranks OPENCODE_API_KEY in processes that load no extensions (isolated subagents, plain pi runs). Run /logout opencode-go to align them.";
		}
	} catch {
		// Missing or unreadable auth.json is not this extension's problem.
	}
	return undefined;
}

function saveDefault(file: KeyFile, label: string): void {
	writeKeyFile({ ...file.body, default: label });
	cached = undefined;
}

export default function (pi: ExtensionAPI) {
	const builtin = builtinProviders().find((provider) => provider.id === "opencode-go");
	if (!builtin?.auth.apiKey) return;
	const builtinAuth = builtin.auth.apiKey;

	const auth = {
		name: "OpenCode Go key file",
		async check(input: AuthInput) {
			let file: KeyFile | undefined;
			try {
				file = readKeyFile();
			} catch {
				// A broken file must still surface the provider, so its error lands on the request.
				return { type: "api_key" as const, source: KEYS_PATH };
			}
			if (file) return { type: "api_key" as const, source: KEYS_PATH };
			const inherited = inheritedPick();
			if (inherited) return { type: "api_key" as const, source: inherited.source };
			const resolved = await builtinAuth.resolve(input);
			return resolved ? { type: "api_key" as const, source: resolved.source } : undefined;
		},
		async resolve(input: AuthInput) {
			const picked = pickKey();
			if (!picked) return builtinAuth.resolve(input);
			return { auth: { apiKey: picked.key }, source: picked.source };
		},
	};

	pi.registerProvider({ ...builtin, auth: { apiKey: auth } });

	pi.on("session_start", (_event, ctx) => {
		let restored: string | undefined;
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type !== "custom" || entry.customType !== ENTRY_TYPE) continue;
			const label = (entry.data as { label?: unknown } | undefined)?.label;
			if (typeof label === "string") restored = label;
		}
		sessionLabel = restored;

		try {
			const picked = pickKey();
			if (!picked) {
				setStatus(ctx, undefined);
				ctx.ui.notify(`No OpenCode Go key file at ${KEYS_PATH}; using built-in credentials.`, "warning");
				flushNote(ctx);
				return;
			}
			exportForChildren(picked.label, picked.key);
			setStatus(ctx, picked.label);
			flushNote(ctx);
		} catch (error) {
			setStatus(ctx, undefined);
			ctx.ui.notify(failure(error), "error");
		}
	});

	pi.registerCommand("key", {
		description: "Show or switch the OpenCode Go API key",
		handler: async (args, ctx) => {
			let file: KeyFile | undefined;
			try {
				file = readKeyFile();
			} catch (error) {
				ctx.ui.notify(failure(error), "error");
				return;
			}
			if (!file) {
				ctx.ui.notify(`No OpenCode Go keys at ${KEYS_PATH}. Create it with "default" and "keys".`, "error");
				return;
			}

			const labels = Object.keys(file.keys);
			const current = activeLabel(file);
			const parts = args.trim().split(/\s+/).filter(Boolean);
			const forDefault = parts[0] === "default";
			let label = forDefault ? parts[1] : parts[0];

			if (!label) {
				if (!ctx.hasUI) {
					ctx.ui.notify(`OpenCode Go keys (current: ${current}): ${labels.join(", ")}`, "info");
					const note = storedCredentialNote();
					if (note) ctx.ui.notify(note, "warning");
					return;
				}
				const options = labels.map((entry) => `${entry}${entry === current ? " (current)" : ""}`);
				const chosen = await ctx.ui.select(
					forDefault ? "Default OpenCode Go key" : `OpenCode Go key (current: ${current})`,
					options,
				);
				if (!chosen) return;
				label = chosen.replace(/ \(current\)$/, "");
			}

			if (!file.keys[label]) {
				ctx.ui.notify(`Unknown key "${label}". Available: ${labels.join(", ")}`, "error");
				return;
			}

			if (forDefault) {
				saveDefault(file, label);
				ctx.ui.notify(`Default OpenCode Go key: ${label}`, "info");
				if (sessionLabel === undefined) {
					const active = pickKey();
					if (active) {
						exportForChildren(active.label, active.key);
						setStatus(ctx, active.label);
					}
				}
				return;
			}

			sessionLabel = label;
			exportForChildren(label, file.keys[label]!);
			pi.appendEntry(ENTRY_TYPE, { label });
			setStatus(ctx, label);
			ctx.ui.notify(`OpenCode Go key for this session: ${label}`, "info");
			flushNote(ctx);
			const note = storedCredentialNote();
			if (note) ctx.ui.notify(note, "warning");
		},
	});
}
