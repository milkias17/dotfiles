/**
 * Copy Last Prompt
 *
 * Ctrl+Shift+X (or /copy-prompt) copies the text of your most recent
 * user message (your last prompt) to the clipboard.
 */

import { copyToClipboard } from "@earendil-works/pi-coding-agent";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type TextPart = { type: string; text?: string };
type UserContent = string | TextPart[];

function userText(content: UserContent): string | undefined {
	if (typeof content === "string") {
		const text = content.trim();
		return text ? text : undefined;
	}
	const text = content
		.filter((part) => part.type === "text" && part.text)
		.map((part) => part.text as string)
		.join("\n")
		.trim();
	return text ? text : undefined;
}

function lastPrompt(ctx: ExtensionContext): string | undefined {
	const entries = ctx.sessionManager.getEntries();
	for (let i = entries.length - 1; i >= 0; i--) {
		const entry = entries[i];
		if (entry.type === "message" && entry.message.role === "user") {
			return userText(entry.message.content as UserContent);
		}
	}
	return undefined;
}

async function copyLastPrompt(ctx: ExtensionContext): Promise<void> {
	const prompt = lastPrompt(ctx);
	if (!prompt) {
		ctx.ui.notify("No user prompt to copy yet", "error");
		return;
	}
	try {
		await copyToClipboard(prompt);
		ctx.ui.notify(`Copied last prompt (${prompt.length} chars)`, "info");
	} catch (error) {
		ctx.ui.notify(`Copy failed: ${(error as Error).message}`, "error");
	}
}

export default function (pi: ExtensionAPI) {
	pi.registerShortcut("ctrl+shift+x", {
		description: "Copy last prompt to clipboard",
		handler: copyLastPrompt,
	});
	pi.registerCommand("copy-prompt", {
		description: "Copy last prompt to clipboard",
		handler: async (_args, ctx) => {
			await copyLastPrompt(ctx);
		},
	});
}
