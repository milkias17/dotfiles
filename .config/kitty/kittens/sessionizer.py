import json
import os
import sys
from typing import Dict, List

from kitty.boss import Boss

SHELL = "fish"
SESSIONS_LOCATION = "~/.config/kitty/sessions"


def main(args: List[str]) -> str:
    while True:
        try:
            answer = input("Enter session name: ")
            if session_file_exists(answer):
                action = input("Overwrite session file? (y or n): ")
                if action == "y":
                    return answer
            else:
                return answer
        except KeyboardInterrupt:
            sys.exit(0)


def session_file_exists(file_name: str) -> bool:
    path = os.path.expanduser(SESSIONS_LOCATION)
    return os.path.exists(f"{path}/{file_name}")


def env_to_str(env: dict):
    return " ".join(f"--env {k}={v}" for k, v in env.items())


def cmdline_to_string(cmdline: list):
    return " ".join(cmdline)


def fg_process_to_string(fg_processes: list):
    fg = fg_processes[0]
    result = ""

    result += cmdline_to_string(fg["cmdline"])

    if result == "kitty @ ls":
        return SHELL

    return result


def get_session_file_string(session_info: List[Dict]) -> str:
    session_file_commands = []
    for os_window in session_info:
        if os_window != session_info[0]:
            session_file_commands.append("new_os_window")
        if os_window.get("is_focused"):
            session_file_commands.append("focus_os_window")

        for tab in os_window["tabs"]:
            tab_title = tab.get("title")
            if tab_title and tab_title != "kitty":
                session_file_commands.append(f"new_tab {tab.get('title') or ''}")

            if tab.get("enabled_layouts"):
                session_file_commands.append(
                    f"enabled_layouts {','.join(tab['enabled_layouts'])}"
                )
            if tab.get("layout"):
                session_file_commands.append(f"layout {tab['layout']}")

            for window in tab["windows"]:
                # Pass if its the sessionizer script
                if "kittens/sessionizer.py" in window["cmdline"]:
                    continue
                session_file_commands.append(f"cd {window['cwd']}")
                session_file_commands.append(
                    f"launch {env_to_str(window['env'])} --hold {fg_process_to_string(window['foreground_processes'])}"
                )
                if window["is_focused"]:
                    session_file_commands.append("focus")

                # command = " ".join(window["foreground_processes"][0]["cmdline"])
                # session_file_commands.append(
                #     "launch {} -C '{} -c \"{}\"'".format(SHELL, SHELL, command)
                # )

    return "\n".join(session_file_commands)


def write_session_file(session_string: str, session_name: str):
    session_path = os.path.expanduser(SESSIONS_LOCATION or "~/.config/kitty/sessions")
    if not os.path.exists(session_path):
        os.mkdir(session_path)

    with open(f"{session_path}/{session_name}", "w") as f:
        f.writelines(session_string)


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    result = boss.call_remote_control(w, ("ls",))

    session_file_string = get_session_file_string(json.loads(result))

    write_session_file(session_file_string, answer)
