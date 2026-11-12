/**
 * pi-update: /update command
 *
 * Updates pi itself (if a newer version exists) and installed pi packages
 * (npm/git extensions) using pi's built-in updater (`pi update --all`), then
 * reloads resources in the running session via ctx.reload() so updated package
 * code is active immediately.
 *
 * Update detection reads pi's own output, not the package manager's. pi prints
 * "Updating <source>..." once per source it actually updates, so those lines are
 * evidence that packages changed. npm's own wording ("changed N packages") is not
 * used: it differs per package manager and a fresh install says "added N packages".
 *
 * Updating pi's own code replaces files that the running process has already
 * loaded, and only a restart can apply them. When pi itself was updated, packages
 * are applied by that same restart, so this command reports the update and skips
 * the reload instead of loading package code out of a replaced installation.
 */

import { execFile } from "node:child_process";
import { promisify } from "node:util";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const run = promisify(execFile);

const STATUS_KEY = "pi-update";
const PI_COMMAND = process.platform === "win32" ? "pi.cmd" : "pi";
const UPDATE_TIMEOUT_MS = 10 * 60_000;

/** SGR sequences from chalk. pi's output is plain when piped, but FORCE_COLOR can add them. */
const ANSI_SGR = /\x1b\[[0-9;]*m/g;

/** "Updated pi from 1.1.0 to 1.2.0", printed only when pi's own code was replaced. */
const PI_UPDATED = /Updated \S+ from \S+ to (\S+)/;

/** "<name> is already up to date (vX.Y.Z)", printed when pi self-update was skipped. */
const PI_CURRENT = /is already up to date \(v[^)]*\)/;

/**
 * pi's package-progress lines: "Updating npm:foo..." for a single source, or
 * "Updating user npm packages..." when several are batched. Both come from the
 * package manager's update path. pi's self-update banners ("Updating pi with npm
 * install ...", "Updating managed pi installation...") contain spaces, so a
 * whitespace-free source cannot match them.
 */
const PACKAGE_UPDATES = /^Updating ((?:user|project) npm packages|\S+)\.\.\.$/gm;

interface UpdateOutcome {
	output: string;
	/** Version pi was updated to, when pi's own code was replaced. */
	piUpdatedTo?: string;
	/** pi reported its own version was already current. */
	piWasCurrent: boolean;
	/** Labels of the sources pi updated, taken from pi's own progress lines. */
	packageUpdates: string[];
}

type UpdateResult =
	| { ok: true; outcome: UpdateOutcome }
	| { ok: false; message: string; outcome: UpdateOutcome };

export default function piUpdateExtension(pi: ExtensionAPI) {
	let updating = false;

	pi.registerCommand("update", {
		description: "Update pi and installed packages, then reload them into this session",
		handler: async (_args, ctx) => {
			if (updating) {
				ctx.ui.notify("An update is already running.", "warning");
				return;
			}
			const confirmed = ctx.hasUI
				? await ctx.ui.confirm("Update", "Run `pi update --all` (pi + packages) now?")
				: true;
			if (!confirmed) return;

			ctx.ui.setStatus(STATUS_KEY, "updating pi and installed packages…");
			updating = true;
			let result: UpdateResult;
			try {
				result = await runPiUpdate();
			} finally {
				// Cleared on every path so no "updating…" status can outlive the command.
				updating = false;
				ctx.ui.setStatus(STATUS_KEY, undefined);
			}

			const { outcome } = result;
			const applied = describeUpdates(outcome);

			if (!result.ok) {
				const lines = [`Update failed: ${result.message}`];
				if (applied.length > 0) {
					// pi updates packages before pi itself, so a later failure can still
					// leave those package updates on disk.
					lines.push(`Already applied before the failure:\n${applied.join("\n")}`);
				}
				lines.push(tail(outcome.output));
				ctx.ui.notify(joinLines(lines), "error");
			} else if (applied.length > 0) {
				ctx.ui.notify(applied.join("\n"), outcome.piUpdatedTo ? "warning" : "info");
			} else if (outcome.piWasCurrent) {
				ctx.ui.notify("pi and all packages up to date", "info");
			} else {
				// pi's wording changed: show its own output rather than claim a result.
				ctx.ui.notify(joinLines(["No updates were applied.", tail(outcome.output)]), "info");
			}

			// A restart replaces pi's code and package code together, so reloading here
			// would only load packages out of a replaced installation.
			if (outcome.piUpdatedTo) return;
			if (outcome.packageUpdates.length === 0) return;

			ctx.ui.setStatus(STATUS_KEY, "reloading extensions…");
			await ctx.reload();
		},
	});
}

async function runPiUpdate(): Promise<UpdateResult> {
	try {
		const result = await run(PI_COMMAND, ["update", "--all"], {
			timeout: UPDATE_TIMEOUT_MS,
			maxBuffer: 16 * 1024 * 1024,
		});
		return { ok: true, outcome: readOutcome(`${result.stdout}\n${result.stderr}`) };
	} catch (error) {
		const failure = error as { stdout?: string; stderr?: string };
		return {
			ok: false,
			message: describeFailure(error),
			outcome: readOutcome(`${failure.stdout ?? ""}\n${failure.stderr ?? ""}`),
		};
	}
}

function readOutcome(rawOutput: string): UpdateOutcome {
	const output = rawOutput.replace(ANSI_SGR, "").replace(/\r/g, "");
	const piUpdated = output.match(PI_UPDATED);
	return {
		output,
		piUpdatedTo: piUpdated?.[1],
		piWasCurrent: PI_CURRENT.test(output),
		packageUpdates: [...output.matchAll(PACKAGE_UPDATES)].map((match) => match[1]),
	};
}

function describeUpdates(outcome: UpdateOutcome): string[] {
	const lines: string[] = [];
	if (outcome.piUpdatedTo) {
		lines.push(`pi updated to ${outcome.piUpdatedTo} — restart pi to apply`);
	}
	if (outcome.packageUpdates.length === 1) {
		lines.push(`Updated ${outcome.packageUpdates[0]}`);
	} else if (outcome.packageUpdates.length > 1) {
		lines.push(`Updated ${outcome.packageUpdates.join(", ")}`);
	}
	return lines;
}

function describeFailure(error: unknown): string {
	const failure = error as { code?: string; killed?: boolean };
	if (failure?.code === "ENOENT") {
		return `Could not run \`${PI_COMMAND}\`. Run \`pi update --all\` in a terminal instead.`;
	}
	if (failure?.killed) {
		return `Timed out after ${UPDATE_TIMEOUT_MS / 60_000} minutes. pi and its package manager may still be running.`;
	}
	// execFile appends the captured output to the message, which the tail already shows.
	const message = error instanceof Error ? error.message : String(error);
	return message.split("\n")[0].trim() || "pi update --all failed.";
}

/** Last few non-empty output lines, so a failure reports why without flooding the UI. */
function tail(text: string, maxLines = 8): string {
	const lines = text.split("\n").filter((line) => line.trim().length > 0);
	return lines.slice(-maxLines).join("\n");
}

function joinLines(lines: string[]): string {
	return lines.filter((line) => line.length > 0).join("\n");
}
