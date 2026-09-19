/**
 * Last Prompt Tokens
 *
 * Shows the size of the working context — the prompt of the most recent LLM
 * call (input + cache read + cache write), i.e. everything the model sees.
 * Useful for deciding when to compact manually before quality degrades.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

function formatTokens(count: number): string {
	if (count < 1000) return count.toString();
	if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1000000) return `${Math.round(count / 1000)}k`;
	return `${(count / 1000000).toFixed(1)}M`;
}

function promptTokens(usage?: { input: number; cacheRead: number; cacheWrite: number }): number | undefined {
	if (!usage) return undefined;
	const total = (usage.input ?? 0) + (usage.cacheRead ?? 0) + (usage.cacheWrite ?? 0);
	return total > 0 ? total : undefined;
}

export default function (pi: ExtensionAPI) {
	const KEY = "last-prompt";

	function setStatus(tokens: number | undefined, ctx: ExtensionContext) {
		if (tokens === undefined) {
			ctx.ui.setStatus(KEY, undefined);
			return;
		}
		ctx.ui.setStatus(KEY, ctx.ui.theme.fg("dim", `working context: ${formatTokens(tokens)}`));
	}

	pi.on("session_start", async (_event, ctx) => {
		// Backfill from session history: find the newest assistant message with usage.
		let latest: number | undefined;
		for (const entry of ctx.sessionManager.getEntries()) {
			if (entry.type === "message" && entry.message.role === "assistant") {
				const t = promptTokens(entry.message.usage);
				if (t !== undefined) latest = t;
			}
		}
		setStatus(latest, ctx);
	});

	pi.on("turn_end", async (event, ctx) => {
		const t = promptTokens(event.message?.usage);
		if (t !== undefined) setStatus(t, ctx);
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		ctx.ui.setStatus(KEY, undefined);
	});
}
