import os
import sys
from typing import Dict, List

from kitty.boss import Boss

SHELL = "fish"


def main(args: List[str]) -> str:
    answer = None
    while session_file_exists(answer := input("Enter session name: ")):
        print("\033[31m" + "Session name already taken!" + "\033[m", file=sys.stderr)

    return answer


def session_file_exists(file_name: str) -> bool:
    home = os.path.expanduser("~")
    return os.path.exists(f"{home}/.config/kitty/sessions/{file_name}")


def get_cmdline(pid: int) -> str:
    try:
        with open(f"/proc/{pid}/cmdline", "r") as f:
            cmdline = f.read()
    except FileNotFoundError:
        return None

    cmdline = cmdline.replace("\x00", " ").strip()
    return cmdline


def get_session_file_string(results: Dict[str, List[Dict[str, str]]]) -> str:
    session_file_commands = []
    for tab in results:
        session_file_commands.append(f"new_tab {tab}")
        for window in results[tab]:
            session_file_commands.append(f"cd {window['cwd']}")
            if window["cmd"]:
                session_file_commands.append(
                    "launch {} -c '{} && {}'".format(
                        SHELL or os.getenv("SHELL"),
                        window["cmd"],
                        SHELL or os.getenv("SHELL"),
                    )
                )
            else:
                session_file_commands.append(f"launch {SHELL or os.getenv('SHELL')}")

    return "\n".join(session_file_commands)


def write_session_file(session_string: str, session_name: str):
    session_path = os.path.expanduser("~/.config/kitty/sessions")
    if not os.path.exists(session_path):
        os.mkdir(session_path)

    with open(f"{session_path}/{session_name}", "w") as f:
        f.writelines(session_string)


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss):
    results = {}
    for tab in boss.all_tabs:
        windows = []
        for window in tab.windows.all_windows:
            window_dict = {}
            window_dict["cwd"] = window.cwd_of_child
            cmdline = get_cmdline(window.child.pid_for_cwd)
            if cmdline is None:
                continue
            window_dict["cmd"] = cmdline
            windows.append(window_dict)
        results[tab.name or tab.active_window.title] = windows

    session_file_string = get_session_file_string(results)
    write_session_file(session_file_string, answer)
