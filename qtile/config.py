import os, psutil
from libqtile import layout, bar, widget, hook, qtile
from libqtile.config import (
    EzKey as Key,
    EzDrag as Drag,
    EzClick as Click,
    lazy,
    Group,
    Screen,
    Match,
    ScratchPad,
    DropDown,
)
import pywal
import colorschemes
from apps import *
from settings import enable_pywal
from libqtile.log_utils import logger
from libqtile.window import Internal

mod = "mod4"
home = os.path.expanduser("~")
config_home = f"{home}/.config"

@hook.subscribe.startup_once
def autostart():
    for app in startup_apps:
        os.system(app)

@hook.subscribe.client_new
def folow_window(client):
    """ When an application with a set match is opened, automatically switch to the new applications group """
    for group in groups:
        match = next((m for m in group.matches if m.compare(client)), None)

        if match:
            targetgroup = qtile.groups_map[group.name]
            targetgroup.cmd_toscreen(toggle=False)
            break

@hook.subscribe.setgroup
def always_on_top():
    """ This makes the firefox picture in picture mode change its group to current group whenever I change group """
    windows = qtile.windows_map.values()
    for window in windows:
        if not isinstance(window, Internal):
            try:
                if window.window.get_name() == "Picture-in-Picture":
                        window.togroup()
            except AttributeError:
                continue

@hook.subscribe.client_new
def swallow(window):
    """ Implements swallow functionality which basically minimizes terminal window if you start a GUI app through it """
    pid = window.window.get_net_wm_pid()
    ppid = psutil.Process(pid).ppid()
    cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
    for i in range(5):
        if not ppid:
            return
        if ppid in cpids:
            parent = window.qtile.windows_map.get(cpids[ppid])
            parent.minimized = True
            window.parent = parent
            return
        ppid = psutil.Process(ppid).ppid()

@hook.subscribe.client_killed
def unswallow(window):
    """ Unminize the terminal window which opened the GUI app """
    if hasattr(window, 'parent'):
        window.parent.minimized = False

keybinds = {
    # Change focus in stack
    "M-k": lazy.layout.up(),
    "M-j": lazy.layout.down(),
    "M-h": lazy.layout.left(),
    "M-l": lazy.layout.right(),
    "M-n": lazy.layout.next(),
    "M-p": lazy.layout.previous(),
    # Change position in stack
    "M-S-k": lazy.layout.shuffle_up(),
    "M-S-j": lazy.layout.shuffle_down(),
    "M-S-h": lazy.layout.swap_left(),
    "M-S-l": lazy.layout.swap_right(),
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
    "M-C-n": lazy.spawn(f"{home}/bin/cycle_walls"),
    "M-C-p": lazy.spawn(f"{home}/bin/cycle_walls prev"),
    "M-S-z": lazy.spawn(f"{home}/bin/google-error"),
    "M-C-y": lazy.spawn(f"{home}/bin/mpv_youtube"),
    # Reload Qtile and Powermenu
    "M-S-e": lazy.spawn(f"{config_home}/rofi/scripts/powermenu"),
    "M-S-r": lazy.restart(),
    "M-S-q": lazy.shutdown(),
    "M-C-l": lazy.spawn(screen_locker),
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
    "C-<Up>": lazy.spawn(f"{home}/bin/msound -i"),
    "C-<Down>": lazy.spawn(f"{home}/bin/msound -d"),
    "M-C-m": lazy.spawn(f"{home}/bin/msound -m"),
}

fonts = ["Iosevka Nerd Font", "Inter Medium"]

if enable_pywal:
    colors = colorschemes.current_scheme
    pywal.sequences.send(colorschemes.data)
else:
    colors = colorschemes.nord

widget_defaults = dict(
    font=fonts[1],
    fontsize=12,
    foreground=colors['white'],
    background=colors["background"],
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=10),
                widget.GroupBox(
                    active=colors["foreground"],
                    background=colors["background"],
                    block_highlight_text_color=colors["foreground"],
                    font=fonts[0],
                    fontsize=18,
                    foreground=colors["foreground"],
                    highlight_method="line",
                    highlight_color=colors["background"],
                    inactive="#717A8B",
                    spacing=4,
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
                    border=colors['cyan_alt'],
                    urgent_border=colors['cyan_alt']
                ),
                widget.Spacer(),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    fontsize=20,
                    text="",
                ),
                widget.Volume(
                    volume_app="pavucontrol",
                    volume_up_command=f"{home}/bin/msound -i",
                    volume_down_command=f"{home}/bin/msound -d",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("pavucontrol")},
                ),
                widget.Sep(padding=15),
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
                ),
                widget.Sep(padding=15),
                widget.CurrentLayout(
                ),
                widget.Sep(padding=15),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    fontsize=20,
                    text="",
                ),
                widget.CPU(
                    format="{load_percent}%",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(task_manager)},
                ),
                widget.Sep(padding=15),
                widget.TextBox(
                    padding=2,
                    font=fonts[0],
                    fontsize=20,
                    text="",
                ),
                widget.Memory(
                    format="{MemUsed}M",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(task_manager)},
                ),
                widget.Sep(padding=15),
                widget.TextBox(
                    padding=0,
                    text="",
                    fontsize=20,
                    font=fonts[0],
                ),
                widget.Clock(
                    format="%A, %B %d  [ %I:%M %p ]",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("gsimplecal")},
                ),
                widget.Sep(padding=15),
                widget.Systray(foreground=colors['foreground']),
            ],
            25,
            background=colors["background"],
            margin=[5, 16, 0, 16], # N E S W
        )
    )
]

layout_theme = dict(
    border_width=3,
    margin=4,
    border_focus=colors["blue"],
    border_normal=colors["background"],
    single_margin=4,
    single_border_width=0,
)

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(),
    layout.MonadWide(**layout_theme),
    layout.Floating(
        border_normal=colors["background"],
        border_focus=colors["foreground"],
        border_width=1,
    ),
]

mouse = [
    Drag("M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]


group_names = [str(i) for i in range(1, 8)]
# group_labels = ["", "", "", "", "", "", ""]
group_labels = ["", "", "", "", "", "", ""]
group_matches = [
    "Brave-browser|firefox",
    "",
    "Eclipse|code-oss",
    "Thunar",
    "Kodi",
    "TelegramDesktop|discord|Hexchat",
    "qBittorrent",
]
groups = list()

for i in range(len(group_names)):
    if not group_matches[i]:
        group = Group(group_names[i], label=group_labels[i])
    else:
        match_names = group_matches[i].split("|")
        matches = list()
        for match in match_names:
            matches.append(Match(wm_class=match))
        group = Group(group_names[i], label=group_labels[i], matches=matches)

    groups.append(group)

keys = [Key(k, v) for k, v in keybinds.items()]

for i in groups:
    keys.extend(
        [
            Key(f"M-{i.name}", lazy.group[i.name].toscreen()),
            Key(f"M-S-{i.name}", lazy.window.togroup(i.name)),
            Key(f"M-C-{i.name}", lazy.window.togroup(i.name, switch_group=True)),
        ]
    )

# ============== ScratchPad ===================
groups.append(
    ScratchPad(
        "scratchpad",
        [DropDown("term", guake_term, on_focus_lost_hide=True, height=0.4),
         DropDown("calc", calculator, on_focus_lost_hide=True)],
    )
)
keys.extend(
    [
        Key("M-<minus>", lazy.group["scratchpad"].dropdown_toggle("term")),
        Key("M-c", lazy.group["scratchpad"].dropdown_toggle("calc"))
    ]
)

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(role="pop-up"),
        Match(wm_class="Lxpolkit"),
        Match(wm_class='Toplevel'),
        Match(wm_class="Redshift-gtk"),
        Match(wm_class=task_manager),
        Match(wm_class="ocs-url"),
        Match(wm_class="usbmaker"),
        Match(wm_class="Gnome-calculator"),
        Match(wm_class="Gcolor2"),
        Match(wm_class="Gsimplecal"),
        Match(wm_class="flameshot"),
    ],
    border_focus=colors["blue"],
    border_normal=colors["background"],
    border_width=3,
)
focus_on_window_activation = "smart"
auto_fullscreen = True

wmname = "LG3D"
