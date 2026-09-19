/**
 * pi-update: /update command
 *
 * Updates pi itself (if a newer version exists) and installed pi packages
 * (npm/git extensions) using pi's built-in updater (`pi update --all`),
 * then reloads resources in the running session via ctx.reload() so updated
 * package code is active immediately.
 *
 * Note: updating pi's own code requires restarting pi — ctx.reload() cannot
 * swap the running binary — so the user is told to restart when applicable.
 */

import { execFile } from "node:child_process";
import { promisify } from "node:util";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const run = promisify(execFile);

export default function piUpdateExtension(pi: ExtensionAPI) {
	pi.registerCommand("update", {
		description: "Update pi and installed packages, then reload them into this session",
		handler: async (_args, ctx) => {
			const ok = ctx.hasUI
				? await ctx.ui.confirm("Update", "Run `pi update --all` (pi + packages) now?")
				: true;
			if (!ok) return;

			ctx.ui.setStatus("pi-update", "updating pi and installed packages…");

			let output: string;
			try {
				const result = await run("pi", ["update", "--all"], {
					timeout: 10 * 60_000,
					maxBuffer: 16 * 1024 * 1024,
				});
				output = `${result.stdout}\n${result.stderr}`.trim();
			} catch (error) {
				ctx.ui.setStatus("pi-update", undefined);
				const anyErr = error as { stdout?: string; stderr?: string; message?: string };
				const detail = `${anyErr.stdout ?? ""}\n${anyErr.stderr ?? ""}`.trim();
				ctx.ui.notify(`Update failed:\n${detail || errorMessage(error)}`, "error");
				return;
			}

			// pi self-update: "Updated pi from X to Y" appears only when it ran.
			const piMatch = output.match(/Updated pi from \S+ to (\S+)/);
			const piUpdatedTo = piMatch ? piMatch[1] : undefined;

			// Package updates: npm prints "changed N package(s)" when it installs.
			const match = output.match(/changed (\d+) package/);
			const changed = match ? Number(match[1]) : -1; // -1 = unrecognized output

			const parts: string[] = [];
			if (piUpdatedTo) parts.push(`pi updated to ${piUpdatedTo} — restart pi to apply`);
			if (changed === 0) parts.push("Packages up to date");

			if (!piUpdatedTo && changed === 0) {
				ctx.ui.setStatus("pi-update", undefined);
				ctx.ui.notify("pi and all packages up to date", "info");
				return;
			}

			if (parts.length > 0) {
				ctx.ui.notify(parts.join("\n"), piUpdatedTo ? "warning" : "info");
			}

			// Only pi's own code changed — nothing to reload into this session.
			if (changed === 0) return;

			// Packages were updated (or output wasn't parseable) — reload so the
			// new code takes effect in this session. Treat reload as terminal;
			// notifications above are sent first for that reason.
			ctx.ui.setStatus(
				"pi-update",
				piUpdatedTo
					? `updated pi${changed > 0 ? ` and ${changed} package(s)` : ""}, reloading…`
					: changed > 0
						? `updated ${changed} package(s), reloading…`
						: "packages updated, reloading…",
			);
			await ctx.reload();
		},
	});
}

function errorMessage(error: unknown): string {
	return error instanceof Error ? error.message : String(error);
}
