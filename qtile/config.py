import os
import subprocess
from libqtile import layout, bar, widget, hook, qtile
from libqtile.config import(
    EzKey as Key,
    EzDrag as Drag,
    EzClick as Click,
    lazy,
    Group,
    Screen,
    Match,
    ScratchPad,
    DropDown
)
import colorschemes
from apps import *

mod = "mod4"
home = os.path.expanduser("~")
config_home = f'{home}/.config'

# Call Autostart script
@hook.subscribe.startup_once
def autostart():
    startup_file = f'{config_home}/qtile/autostart.sh'
    subprocess.call([startup_file])

@hook.subscribe.client_new
def modify_window(client):
    for group in groups:
        match = next((m for m in group.matches if m.compare(client)), None)

        if match:
            targetgroup = client.qtile.groups_map[group.name]
            targetgroup.cmd_toscreen(toggle=False)
            break

keybinds = {
    # Change focus in stack
    'M-k' : lazy.layout.up(),
    'M-j' : lazy.layout.down(),
    'M-h' : lazy.layout.left(),
    'M-l' : lazy.layout.right(),
    'M-n' : lazy.layout.next(),
    'M-p' : lazy.layout.previous(),

    # Change position in stack
    'M-S-k' : lazy.layout.shuffle_up(),
    'M-S-j' : lazy.layout.shuffle_up(),
    'M-S-h' : lazy.layout.swap_left(),
    'M-S-l' : lazy.layout.swap_right(),

    # Resize windows in stack
    'M-i' : lazy.layout.grow(),
    'M-s' : lazy.layout.shrink(),
    'M-S-m' : lazy.layout.maximize(),
    'M-S-n' : lazy.layout.normalize(),
    
    # Run applications
    'M-<Return>' : lazy.spawn(terminal),
    'M-b' : lazy.spawn(browser),
    'M-e' : lazy.spawn(entertainment),
    'M-c' : lazy.spawn(chat),
    'M-S-d' : lazy.spawn(editor),
    'M-d' : lazy.spawn("rofi -show drun"),
    'M-S-f' : lazy.spawn(fm),
    'M-<F1>' : lazy.spawn(f'{config_home}/rofi/scripts/config-files'),
    'M-<F2>' : lazy.spawn(task_manager),
    'M-S-c' : lazy.spawn(calculator),
    'M-S-x' : lazy.spawn('xkill'),
    '<Print>': lazy.spawn(screenshot),
    'M-C-n': lazy.spawn(f'{home}/bin/cycle_walls'),
    'M-C-p': lazy.spawn(f'{home}/bin/cycle_walls prev'),

    # Reload Qtile and Powermenu
    'M-S-e' : lazy.spawn(f'{config_home}/rofi/scripts/powermenu'),
    'M-S-r' : lazy.restart(),
    'M-S-q' : lazy.shutdown(),
    'M-C-l' : lazy.spawn(screen_locker),

    # Layout operations
    'M-<Tab>' : lazy.next_layout(),
    'M-S-<Tab>' : lazy.prev_layout(),
    'M-<space>' : lazy.layout.flip(),

    # Window operations
    'M-q' : lazy.window.kill(),
    'M-S-<space>' : lazy.window.toggle_floating(),
    'M-f' : lazy.window.toggle_fullscreen(),
    'M-m': lazy.window.toggle_minimize(),

    # Volume keys
    'C-<Up>' : lazy.spawn(f'{home}/bin/i3-volume -i 10 -lny -x 500'),
    'C-<Down>' : lazy.spawn(f'{home}/bin/i3-volume -d 10 -lny -x 500'),
    'M-C-m' : lazy.spawn(f'{home}/bin/i3-volume -m -lny'),
}

fonts = ['Iosevka Nerd Font', 'Inter Medium']

colors = colorschemes.nord
color1 = colors['blue_alt']
color2 = colors['black']

widget_defaults = dict(
    font = fonts[1],
    fontsize = 12,
    foreground = colors['foreground'],
    background = colors['background'],
    padding = 3
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top = bar.Bar(
            [
                widget.GroupBox(
                    active = colors['foreground'],
                    background = colors['background'],
                    block_highlight_text_color = colors['foreground'],
                    font = fonts[0],
                    fontsize = 18,
                    foreground = colors['foreground'],
                    highlight_method = 'line',
                    highlight_color = colors['background'],
                    inactive = "#717A8B",
                    spacing = 4,
                    urgent_alert_method = 'block',
                    urgent_border = colors['red'],
                    urgent_text = colors['foreground'],
                    margin_x = 0,
                    margin_y = 2,
                    padding = 4,
                    border_width = 4,
                    rounded = False,
                    this_current_screen_border = colors['blue']
                ),
                widget.Spacer(length = 15),
                widget.TaskList(
                    highlight_method = 'block',
                    border = colors['blue_alt'],
                    icon_size = 18,
                    fontsize = 14,
                    max_title_width = 150,
                ),
                widget.Spacer(),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = colors['background'],
                    foreground = color1,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    fontsize = 20,
                    text = "",
                    background = color1,
                    foreground = colors['foreground']
                ),
                widget.Volume(
                    background = color1,
                    foreground = colors['foreground'],
                    volume_app = 'pavucontrol',
                    volume_up_command = f"{home}/bin/i3-volume -i 10 -lny -x 500",
                    volume_down_command = f"{home}/bin/i3-volume -d 10 -lny -x 500",
                    mouse_callbacks = {'Button1' : lambda: qtile.cmd_spawn('pavucontrol')}
                ),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = color1,
                    foreground = color2,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    text = "",
                    background = color2,
                    foreground = colors['foreground'],
                    fontsize = 20
                ),
                widget.CheckUpdates(
                    background = color2,
                    foreground = colors['foreground'],
                    colour_have_updates = colors['foreground'],
                    colour_no_updates = colors['foreground'],
                    display_format = '{updates}'
                ),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = color2,
                    foreground = color1,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.CurrentLayout(
                    background = color1,
                    foreground = colors['foreground'],
                ),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = color1,
                    foreground = color2,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    fontsize = 20,
                    text = "",
                    background = color2,
                    foreground = colors['foreground']
                ),
                widget.CPU(
                    format = '{load_percent}%',
                    background = color2,
                    foreground = colors['foreground'],
                    mouse_callbacks = {'Button1' : lambda: qtile.cmd_spawn(task_manager)}
                ),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = color2,
                    foreground = color1,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    fontsize = 20,
                    text =  "",
                    background = color1,
                    foreground = colors['foreground']
                ),
                widget.Memory(
                    background = color1,
                    foreground = colors['foreground'],
                    format = '{MemUsed}M',
                    mouse_callbacks = {'Button1' : lambda: qtile.cmd_spawn(task_manager)}
                ),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = color1,
                    foreground = color2,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.TextBox(
                    padding = 0,
                    background = color2,
                    foreground = colors['foreground'],
                    text = "",
                    fontsize = 20,
                    font = fonts[0],
                ),
                widget.Clock(
                    background = color2,
                    foreground = colors['foreground'],
                    format = "%A, %B %d  [ %I:%M %p ]",
                    mouse_callbacks = {'Button1' : lambda: qtile.cmd_spawn('gsimplecal')}
                ),
                widget.TextBox(
                    width = 20,
                    # text = '',
                    text = "⚈",
                    background = color2,
                    foreground = color1,
                    padding = 0,
                    font = fonts[0],
                    fontsize = 36,
                   ),
                widget.Systray(
                    background = color1,
                    foreground = colors['foreground']
                ),
            ],
            25,
            background = colors['background']
        )
    )
]

layout_theme = dict(
    border_width = 2,
    margin = 6,
    border_focus = colors['foreground'],
    border_normal = colors['background'],
    single_margin = 0,
    single_border_width = 0
)

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(),
    layout.Floating(border_normal = colors['background'],
                    border_focus = colors['foreground'],
                    border_width = 1),
]

mouse = [
    Drag('M-1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag('M-3',
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click('A-1',
          lazy.window.bring_to_front())
]


group_names = [str(i) for i in range(1, 10)]
group_labels = ["", "", "", "", "", "", "", "", ""]
group_matches = ["Brave-browser|firefox",
                 "",
                 "Eclipse|code-oss",
                 "Thunar",
                 "Kodi",
                 "TelegramDesktop|discord|Hexchat",
                 "qBittorrent",
                 "Com.github.needleandthread.vocal|Audacious",
                 ""]
groups = list()

for i in range(len(group_names)):
    if not group_matches[i]:
        tmp = Group(group_names[i], label=group_labels[i])
    else:
        match_names = group_matches[i].split("|")
        matches = list()
        for match in match_names:
            matches.append(Match(wm_class=match))
        tmp = Group(group_names[i], label=group_labels[i], matches=matches)

    groups.append(tmp)

keys = [Key(k, v) for k, v in keybinds.items()]

for i in groups:
    keys.extend([
        Key(f'M-{i.name}', lazy.group[i.name].toscreen()),
        Key(f'M-S-{i.name}', lazy.window.togroup(i.name)),
        Key(f'M-C-{i.name}', lazy.window.togroup(i.name, switch_group=True))
    ])

# ============== ScratchPad ===================
groups.append(ScratchPad("scratchpad", [
    DropDown("term", guake_term, on_focus_lost_hide=True, height=0.4)
]))
keys.extend([
    Key('M-<minus>', lazy.group['scratchpad'].dropdown_toggle('term')),
])

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(float_rules= [
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(role='pop-up'),
    Match(wm_class='Lxpolkit'),
    Match(wm_class='Redshift-gtk'),
    Match(wm_class='Pychess'),
    Match(wm_class='Toplevel'),
    Match(wm_class='Arena_x86_64_linux'),
    Match(wm_class=task_manager),
    Match(wm_class='ocs-url'),
    Match(wm_class='usbmaker'),
    Match(wm_class='Gnome-calculator'),
    Match(wm_class='Gcolor2'),
    Match(wm_class='Gsimplecal'),
    Match(wm_class='flameshot')
],
    border_focus = colors['foreground'],
    border_normal = colors['background'],
    border_width = 2
)
focus_on_window_activation = "smart"
auto_fullscreen = True

wmname = "LG3D"
