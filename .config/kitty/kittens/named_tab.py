import os
from typing import List

from kitty.boss import Boss

SHELL = "fish"


def main(args: List[str]) -> str:
    tab_title = input("Enter tab title: ")
    return tab_title


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss):
    window = boss.window_id_map.get(target_window_id)
    if window is not None:
        boss.call_remote_control(
            window,
            (
                "launch",
                "--type=tab",
                "--tab-title",
                answer,
                SHELL or os.getenv("SHELL"),
            ),
        )
