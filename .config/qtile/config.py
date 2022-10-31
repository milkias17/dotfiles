import json
import os
import subprocess

import psutil
from libqtile import bar, hook, layout, qtile, widget
from libqtile.backend.x11.window import Internal
from libqtile.config import DropDown
from libqtile.config import EzClick as Click
from libqtile.config import EzDrag as Drag
from libqtile.config import EzKey as Key
from libqtile.config import Group, Match, ScratchPad, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger

from colorschemes import get_colorscheme
from apps import (browser, calculator, chat, editor, entertainment, fm,
                  guake_term, screen_locker, screenshot, startup_apps,
                  task_manager, terminal)
from settings import enable_pywal, load_session, colorscheme

if enable_pywal:
    import pywal

mod = "mod4"
home = os.path.expanduser("~")
config_home = f"{home}/.config"
bin_dir = f"{home}/bin"


@lazy.function
def float_to_front(qtile):
    for window in qtile.current_group.windows:
        if window.floating:
            window.cmd_bring_to_front()


@lazy.function
def next_window(qtile):
    """Cycle to next window in group whether it is minimized or not"""
    group = qtile.current_group
    index = group.windows.index(group.current_window)
    if index == len(group.windows) - 1:
        index = -1
    group.focus(group.windows[index + 1])


@lazy.function
def prev_window(qtile):
    group = qtile.current_group
    index = group.windows.index(group.current_window)
    group.focus(group.windows[index - 1])


@lazy.function
def toggle_always_on_top(qtile):
    pid = qtile.current_window.window.get_net_wm_pid()
    if pid in aot_windows["wm_pid"]:
        aot_windows["wm_pid"].remove(pid)
    else:
        aot_windows["wm_pid"].append(pid)


def reload_session():
    with open(os.path.expanduser("~/.local/share/qtile/save-session.json")) as file:
        session = json.load(file)

        for group in session:
            for window in session[group]:
                group_label = session[group][window]["group"]
                cmd = session[group][window]["cmd"]
                os.system(f"qtile run-cmd -g {group_label} {cmd} &")


@hook.subscribe.startup_once
def autostart():
    for app in startup_apps:
        os.system(app)

    if load_session:
        reload_session()


@hook.subscribe.shutdown
def save_session(window):
    with open(os.path.expanduser("~/.local/share/qtile/save-session.json"), "w") as f:
        info = dict()
        for group in qtile.groups:
            for window in group.windows:
                if window.group.name != "scratchpad":
                    pid = window.window.get_net_wm_pid()
                    info[f"group-{window.group.name}"] = {
                        f"{pid} | {window.window.get_wm_class()[1]}": dict(
                            pid=pid,
                            cmd=subprocess.getoutput(
                                f"ps -p {pid} -o args | sed -n 2p"
                            ),
                            group=window.group.name,
                            group_index=group.windows.index(window),
                        )
                    }

        json.dump(info, f, indent=2)


aot_windows = {
    "wm_name": ["Picture-in-Picture", "Picture in picture"],
    "wm_pid": [],
}


def check_match(type, value):
    return value in aot_windows[type]


@hook.subscribe.client_new
def follow_window(client):
    """When an application with a set match is opened, automatically switch to
    the new applications group and always bring firefox picture in picture to front"""
    for group in groups:
        match = next((m for m in group.matches if m.compare(client)), None)

        if match:
            targetgroup = qtile.groups_map[group.name]
            targetgroup.cmd_toscreen(toggle=False)
            break

    cur_group = qtile.current_group
    for window in cur_group.windows:
        if check_match("wm_name", window.window.get_name()) or check_match(
            "wm_pid", window.window.get_net_wm_pid()
        ):
            window.cmd_bring_to_front()


@hook.subscribe.focus_change
async def fix_scratchpad():
    window = qtile.current_window
    scratchpad_group = next(
        (group for group in qtile.groups if group.name == "scratchpad"), None
    )
    if scratchpad_group is None:
        return

    scratchpad_windows = [
        dropdown.window for dropdown in scratchpad_group.dropdowns.values()
    ]
    if window in scratchpad_windows:
        window.cmd_bring_to_front()


@hook.subscribe.setgroup
def always_on_top():
    """Makes all windows defined as always on top switch to current group you are in"""
    windows = qtile.windows_map.values()
    for window in windows:
        if not isinstance(window, Internal) and not isinstance(window, widget.Systray):
            try:
                if check_match("wm_name", window.window.get_name()) or check_match(
                    "wm_pid", window.window.get_net_wm_pid()
                ):
                    if qtile.current_group.focus_history:
                        focused_win = qtile.current_group.focus_history[-1]
                        window.togroup()
                        qtile.current_group.focus(focused_win)
                    else:
                        window.togroup()
            except AttributeError:
                continue


@hook.subscribe.client_new
def swallow(window):
    """Implements swallow functionality which basically minimizes terminal window if you start a GUI app through it"""
    pid = window.window.get_net_wm_pid()
    ppid = psutil.Process(pid).ppid()
    cpids = {
        c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()
    }
    for _ in range(5):
        if not ppid:
            return
        if ppid in cpids:
            parent = window.qtile.windows_map.get(cpids[ppid])
            if parent.window.get_wm_class()[1] == "kitty":
                parent.minimized = True
                window.parent = parent
            return
        ppid = psutil.Process(ppid).ppid()


@hook.subscribe.client_killed
def unswallow(window):
    """Unminize the terminal window which opened the GUI app"""
    if hasattr(window, "parent"):
        window.parent.minimized = False


keybinds = {
    "M-S-b": lazy.hide_show_bar(position="all"),
    # Change focus in stack
    "M-k": lazy.layout.up(),
    "M-j": lazy.layout.down(),
    "M-h": lazy.layout.left(),
    "M-l": lazy.layout.right(),
    "M-n": next_window,
    "M-p": prev_window,
    "M-C-a": toggle_always_on_top,
    # Change position in stack
    "M-S-k": lazy.layout.shuffle_up(),
    "M-S-j": lazy.layout.shuffle_down(),
    "M-S-h": lazy.layout.swap_left(),
    "M-S-l": lazy.layout.swap_right(),
    "M-C-f": float_to_front,
    # Resize windows in stack
    "M-i": lazy.layout.grow(),
    "M-s": lazy.layout.shrink(),
    "M-S-m": lazy.layout.maximize(),
    "M-S-n": lazy.layout.normalize(),
    # Run applications
    "M-<Return>": lazy.spawn(terminal),
    "M-b": lazy.spawn(browser),
    "M-C-e": lazy.spawn(entertainment),
    "M-S-t": lazy.spawn(chat),
    "M-S-d": lazy.spawn(editor),
    "M-d": lazy.spawn("rofi -show drun"),
    "M-S-f": lazy.spawn(fm),
    "M-<F1>": lazy.spawn(f"{config_home}/rofi/scripts/config-files"),
    "M-<F2>": lazy.spawn(task_manager),
    "M-S-x": lazy.spawn("xkill"),
    "M-<Print>": lazy.spawn(screenshot),
    "M-C-p": lazy.spawn("audacious -t"),
    "M-C-n": lazy.spawn("audacious -f"),
    "M-C-b": lazy.spawn("audacious -r"),
    "M-S-z": lazy.spawn(f"{bin_dir}/google-error"),
    "M-C-y": lazy.spawn(f"{bin_dir}/mpv_youtube"),
    # Reload Qtile and Powermenu
    "M-S-e": lazy.spawn(f"{config_home}/rofi/scripts/powermenu"),
    "M-C-l": lazy.spawn(screen_locker),
    "M-S-r": lazy.restart(),
    "M-S-q": lazy.shutdown(),
    # Layout operations
    "M-<Tab>": lazy.next_layout(),
    "M-S-<Tab>": lazy.prev_layout(),
    "M-<space>": lazy.layout.flip(),
    # Window operations
    "M-q": lazy.window.kill(),
    "M-S-<space>": lazy.window.toggle_floating(),
    "M-f": lazy.window.toggle_fullscreen(),
    "M-m": lazy.window.toggle_minimize(),
    # Volume keys
    "C-<Up>": lazy.spawn(f"{bin_dir}/msound -i"),
    "C-<Down>": lazy.spawn(f"{bin_dir}/msound -d"),
    "M-C-m": lazy.spawn(f"{bin_dir}/msound -m"),
    # Notification shortcuts
    "A-<space>": lazy.spawn("dunstctl close"),
    "C-S-<space>": lazy.spawn("dunstctl close-all"),
    "C-<grave>": lazy.spawn("dunstctl history-pop"),
}

fonts = ["Iosevka Nerd Font", "Inter Medium",
         "Sora Regular", "Symbols Nerd Font"]

if enable_pywal:
    colors = get_colorscheme()
else:
    colors = get_colorscheme(colorscheme)

widget_defaults = dict(
    font=fonts[2],
    fontsize=12,
    foreground=colors["foreground"],
    background=colors["background"],
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                # widget.Spacer(length=3),
                widget.GroupBox(
                    active=colors["foreground"],
                    background=colors["background"],
                    block_highlight_text_color=colors["foreground"],
                    fontsize=14,
                    foreground=colors["foreground"],
                    highlight_method="line",
                    highlight_color=colors["background"],
                    inactive="#717A8B",
                    spacing=2,
                    urgent_alert_method="block",
                    urgent_border=colors["red"],
                    urgent_text=colors["foreground"],
                    margin_x=0,
                    margin_y=2,
                    padding=4,
                    border_width=4,
                    rounded=False,
                    this_current_screen_border=colors["blue"],
                ),
                widget.Spacer(length=15),
                widget.TaskList(
                    highlight_method="block",
                    icon_size=18,
                    fontsize=14,
                    max_title_width=150,
                    title_width_method="uniform",
                    border=colors["blue"],
                    foreground=colors["foreground"],
                    urgent_border=colors["blue_alt"],
                    spacing=3,
                    txt_floating="🗗",
                    txt_maximized="🗖",
                    txt_minimized="🗕",
                ),
                # widget.Spacer(),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    fontsize=20,
                    text="",
                ),
                widget.Volume(
                    volume_app="pavucontrol",
                    volume_up_command=f"{bin_dir}/msound -i",
                    volume_down_command=f"{bin_dir}/msound -d",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("pavucontrol")},
                    get_volume=f"{bin_dir}/msound",
                ),
                widget.Spacer(length=8),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    text="",
                    fontsize=20,
                ),
                widget.CheckUpdates(
                    colour_have_updates=colors["foreground"],
                    colour_no_updates=colors["foreground"],
                    display_format="{updates}",
                    no_update_string="N/A",
                ),
                widget.Spacer(length=8),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    fontsize=20,
                    text="",
                ),
                widget.CPU(
                    format="{load_percent}%",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(task_manager)},
                ),
                widget.Spacer(length=8),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    fontsize=20,
                    text="",
                ),
                widget.Memory(
                    format="{MemUsed: .0f}M",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(task_manager)},
                ),
                widget.Spacer(length=8),
                widget.TextBox(
                    padding=0,
                    text="",
                    fontsize=20,
                    font=fonts[0],
                ),
                widget.Clock(
                    format="%a, %b %d  %I:%M %p",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("gsimplecal")},
                ),
                widget.Spacer(length=3),
                widget.CurrentLayoutIcon(),
                widget.Spacer(length=3),
                widget.Systray(foreground=colors["foreground"]),
            ],
            25,
            background=colors["background"],
            # margin=[5, 16, 0, 16],  # N E S W,
            # opacity=0.9,
        )
    )
]

layout_theme = dict(
    border_width=2,
    margin=4,
    border_focus=colors["blue"],
    border_normal=colors["background"],
    single_margin=0,
    single_border_width=0,
)

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(),
    layout.MonadWide(**layout_theme),
    layout.Floating(
        border_normal=colors["background"],
        border_focus=colors["foreground"],
        border_width=0,
    ),
]

mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]


group_names = [str(i) for i in range(1, 8)]
# group_labels = ["", "", "", "", "", "", ""]
# group_labels = ["", "", "", "", "", "", ""]
# group_labels = ["", "", "", "", "", "", "", "", ""]
group_labels = [str(i) for i in range(1, 8)]
group_matches = [
    "Brave-browser|firefox",
    "",
    "Eclipse|code-oss",
    "Thunar",
    "Kodi|Stremio",
    "TelegramDesktop|discord|Hexchat",
    "qBittorrent",
]
groups = list()

for i in range(len(group_names)):
    if not group_matches[i]:
        group = Group(group_names[i], label=group_labels[i])
    else:
        match_names = group_matches[i].split("|")
        matches = [Match(wm_class=match) for match in match_names]
        group = Group(group_names[i], label=group_labels[i], matches=matches)

    groups.append(group)

keys = [Key(k, v) for k, v in keybinds.items()]

for i in groups:
    keys.extend(
        [
            Key(f"M-{i.name}", lazy.group[i.name].toscreen(toggle=True)),
            Key(f"M-S-{i.name}", lazy.window.togroup(i.name)),
            Key(f"M-C-{i.name}", lazy.window.togroup(i.name, switch_group=True)),
        ]
    )

# ============== ScratchPad ===================
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                guake_term,
                height=0.6,
                width=0.6,
                y=0.2,
                x=0.2,
                warp_pointer=False,
            ),
            DropDown("calc", calculator, on_focus_lost_hide=True),
        ],
    )
)
keys.extend(
    [
        Key("M-<minus>", lazy.group["scratchpad"].dropdown_toggle("term")),
        Key("M-c", lazy.group["scratchpad"].dropdown_toggle("calc")),
    ]
)

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="Lxpolkit"),
        Match(wm_class="Toplevel"),
        Match(wm_class="Redshift-gtk"),
        Match(wm_class=task_manager),
        Match(wm_class="ocs-url"),
        Match(wm_class="usbmaker"),
        Match(wm_class="Gnome-calculator"),
        Match(wm_class="Gcolor3"),
        Match(wm_class="Gsimplecal"),
        Match(wm_class="flameshot"),
        Match(wm_class="Nm-connection-editor"),
    ],
    border_focus=colors["red"],
    border_normal=colors["background"],
    border_width=0,
)
focus_on_window_activation = "never"
auto_fullscreen = True

wmname = "LG3D"
