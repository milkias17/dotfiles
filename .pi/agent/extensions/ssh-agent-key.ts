/**
 * SSH Agent Key
 *
 * Loads ~/.ssh/id_ed25519 into the running ssh-agent when a session starts.
 *
 * pi-sandbox keeps ~/.ssh out of the sandbox, so a sandboxed `git push` over
 * SSH has no identity to sign with. Extensions run inside the Pi process,
 * outside the sandbox, so this `ssh-add` can read the key; the sandboxed ssh
 * then signs through the agent, whose socket is still reachable inside.
 */

import { spawnSync } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const KEY = join(homedir(), ".ssh", "id_ed25519");

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		const listed = spawnSync("ssh-add", ["-l"], { encoding: "utf8", timeout: 5000 });
		if (listed.status === 0 && listed.stdout.includes("id_ed25519")) return;

		const added = spawnSync("ssh-add", [KEY], {
			encoding: "utf8",
			timeout: 5000,
			// ssh-add reads /dev/tty directly, which would hang the TUI on a
			// passphrase-protected key. Force askpass so it fails fast instead.
			env: { ...process.env, SSH_ASKPASS_REQUIRE: "force", SSH_ASKPASS: "/bin/false" },
		});
		if (added.status !== 0) {
			ctx.ui.notify(`ssh-agent-key: ${added.stderr.trim() || "ssh-add failed"}`, "error");
		}
	});
}
