import os
import subprocess
from libqtile import layout, bar, widget, hook
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

mod = "mod4"
terminal = "kitty -1"
browser = "brave"
fm = "thunar"
home = os.path.expanduser("~")

# Call Autostart script
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])

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

    # Change position in stack
    'M-S-k' : lazy.layout.shuffle_up(),
    'M-S-j' : lazy.layout.shuffle_up(),
    'M-S-h' : lazy.layout.swap_left(),
    'M-S-l' : lazy.layout.swap_right(),

    # Resize windows in stack
    'M-i' : lazy.layout.grow(),
    'M-m' : lazy.layout.shrink(),
    'M-S-m' : lazy.layout.maximize(),
    'M-S-n' : lazy.layout.normalize(),
    
    # Run application
    'M-<Return>' : lazy.spawn(terminal),
    'M-b' : lazy.spawn(browser),
    'M-d' : lazy.spawn("rofi -show drun"),
    'M-S-f' : lazy.spawn(fm),
    'M-<F1>' : lazy.spawn(f'{home}/.config/rofi/scripts/config-files'),
    'M-<F2>' : lazy.spawn(f"{home}/.config/rofi/scripts/font-preview"),
    'M-S-c' : lazy.spawn('gnome-calculator'),
    'M-S-x' : lazy.spawn('xkill'),

    # Reload Qtile and Powermenu
    'M-S-e' : lazy.spawn(f'{home}/.config/rofi/scripts/powermenu'),
    'M-S-r' : lazy.restart(),
    'M-S-q' : lazy.shutdown(),
    'M-C-l' : lazy.spawn(f'betterlockscreen -l'),

    # Layout operations
    'M-<Tab>' : lazy.next_layout(),
    'M-S-<Tab>' : lazy.prev_layout(),
    'M-C-<Return>' : lazy.layout.toggle_split(),
    'M-<space>' : lazy.layout.flip(),

    # Window operations
    'M-q' : lazy.window.kill(),
    'M-S-<space>' : lazy.window.toggle_floating(),
    'M-f' : lazy.window.toggle_fullscreen(),

    # Volume keys
    'C-<Up>' : lazy.spawn(f'{home}/bin/i3-volume -i 10 -lny -x 500'),
    'C-<Down>' : lazy.spawn(f'{home}/bin/i3-volume -d 10 -lny -x 500'),
    'M-C-m' : lazy.spawn(f'{home}/bin/i3-volume -m -lny'),
}

colors = colorschemes.nord
fonts = ['Iosevka Nerd Font', 'Inter Medium']

screens = [
    Screen(
        top = bar.Bar(
            [
                widget.GroupBox(
                    active = colors['foreground'],
                    background = colors['background'],
                    block_highlight_text_color = colors['foreground'],
                    border_width = 4,
                    font = fonts[0],
                    fontsize = 18,
                    foreground = colors['foreground'],
                    highlight_method = 'block',
                    highlight_color = colors['cyan_alt'],
                    inactive = colors['foreground'],
                    spacing = 3,
                    urgent_alert_method = 'block',
                    urgent_border = colors['red'],
                    urgent_text = colors['foreground'],
                    margin_x = 0,
                    margin_y = 2,
                    padding_x = 2,
                    padding_y = 0,
                    rounded = False,
                    this_current_screen_border = colors['cyan_alt']
                ),
                widget.WindowName(
                    font = fonts[1],
                    fontsize = 12,
                    foreground = colors['foreground'],
                    padding = 30,
                ),
                widget.Spacer(),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['background'],
                    foreground = colors['blue'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    fontsize = 20,
                    text = "",
                    background = colors['blue'],
                    foreground = colors['foreground']
                ),
                widget.Volume(
                    font = fonts[1],
                    fontsize = 12,
                    background = colors['blue'],
                    foreground = colors['foreground'],
                    volume_app = 'pavucontrol',
                    volume_up_command = f"{home}/bin/i3-volume -i 10 -lny -x 500",
                    volume_down_command = f"{home}/bin/i3-volume -d 10 -lny -x 500"
                ),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['blue'],
                    foreground = colors['background'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    text = "",
                    background = colors['background'],
                    foreground = colors['foreground'],
                    fontsize = 20
                ),
                widget.CheckUpdates(
                    background = colors['background'],
                    foreground = colors['foreground'],
                    colour_have_updates = colors['foreground'],
                    colour_no_updates = colors['foreground'],
                    display_format = '{updates}'
                ),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['background'],
                    foreground = colors['blue'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.CurrentLayout(
                    background = colors['blue'],
                    foreground = colors['foreground'],
                ),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['blue'],
                    foreground = colors['background'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    fontsize = 20,
                    text = "",
                    background = colors['background'],
                    foreground = colors['foreground']
                ),
                widget.CPU(
                    format = '{load_percent}%',
                    font = fonts[1],
                    fontsize = 12,
                    background = colors['background'],
                    foreground = colors['foreground']
                ),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['background'],
                    foreground = colors['blue'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.TextBox(
                    padding = 2,
                    font = fonts[0],
                    fontsize = 20,
                    text =  "",
                    background = colors['blue'],
                    foreground = colors['foreground']
                ),
                widget.Memory(
                    background = colors['blue'],
                    foreground = colors['foreground'],
                    font = fonts[1],
                    fontsize = 12,
                    format = '{MemUsed}M',
                ),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['blue'],
                    foreground = colors['background'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.TextBox(
                    padding = 0,
                    background = colors['background'],
                    foreground = colors['foreground'],
                    text = "",
                    fontsize = 20,
                    font = fonts[0],
                ),
                widget.Clock(
                    background = colors['background'],
                    foreground = colors['foreground'],
                    format = "%A, %B %d  [ %I:%M %p ]",
                    font = fonts[1]
                ),
                widget.TextBox(
                    width = 20,
                    text = '',
                    background = colors['background'],
                    foreground = colors['blue'],
                    padding = 0,
                    font = fonts[0],
                    fontsize = 50,
                   ),
                widget.Systray(
                    background = colors['blue'],
                    foreground = colors['foreground']
                ),
            ],
            25,
            background = colors['background'],
            opacity = 0.87,
            margin = [0, -4, 0, -4]
        )
    )
]

layout_theme = dict(
    border_width = 0,
    margin = 6,
    border_focus = colors['background'],
    border_normal = colors['background'],
    single_margin = 0,
    single_border = 0
)

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(),
    layout.Floating(border_normal = colors['background'],
                    border_focus = colors['background'],
                    border_width = 1)
]

mouse = [
    Drag('M-1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag('M-3',
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click('M-2', lazy.window.bring_to_front())
]


group_names = [str(i) for i in range(1, 10)]
group_labels = ["", "", "", "", "漣", "", "", "", ""]
group_matches = ["Brave-browser|firefox",
                 "Eclipse|code-oss",
                 "Thunar",
                 "Kodi",
    "Lxappearance|Kvantum Manager|Nitrogen|Pavucontrol|me-guoyunhe-fontweak-MainWindow|Grub-customizer",
    "TelegramDesktop|discord|Hexchat",
                 "qBittorrent|xdman-Main",
                 "Com.github.needleandthread.vocal|Audacious",
                 ""]
groups = list()

for i in range(len(group_names)):
    if not group_matches[i]:
        tmp = Group(group_names[i], label=group_labels[i])
    else:
        matche_names = group_matches[i].split("|")
        matches = list()
        for match in matche_names:
            matches.append(Match(wm_class=match))
        tmp = Group(group_names[i], label=group_labels[i], matches=matches)

    groups.append(tmp)

keys = [Key(k, v) for k, v in keybinds.items()]

# Screenshot keybind
keys.append(Key('<Print>', 
                lazy.spawn(f'scrot {home}/Pictures/Screenshots/%Y-%m-%d-%T-scrot.png'),
                lazy.spawn("dunstify 'Screenshot Taken!'")))

for i in groups:
    if i.name == 'scratchpad':
        continue
    keys.extend([
        Key(f'M-{i.name}', lazy.group[i.name].toscreen()),
        Key(f'M-S-{i.name}', lazy.window.togroup(i.name)),
        Key(f'M-C-{i.name}', lazy.window.togroup(i.name, switch_group=True))
    ])

# ============== ScratchPad ===================
groups.append(ScratchPad("scratchpad", [
    DropDown("term", "xterm",
            on_focus_lost_hide=True,
            x = 0.2,
            y = 0.2,
            width = 0.6,
            height = 0.7)
]))
keys.extend([
    Key('M-<minus>', lazy.group['scratchpad'].dropdown_toggle('term')),
])

follow_mouse_focus = True
bring_front_click = True
cursor_warp = False

floating_layout = layout.Floating(float_rules= [
    Match(title='Quit and close tabs?'),
    Match(wm_type='utility'),
    Match(wm_type='notification'),
    Match(wm_type='toolbar'),
    Match(wm_type='splash'),
    Match(wm_type='dialog'),
    Match(wm_class='Conky'),
    Match(wm_class='Firefox'),
    Match(wm_class='file_progress'),
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='Lxpolkit'),
    Match(wm_class='Redshift-gtk'),
    Match(wm_class='usbmaker'),
    Match(wm_class='Gnome-calculator'),
    Match(wm_class='Gcolor2'),
    Match(wm_class='Gsimplecal'),
    Match(wm_class='xdman-Main')
],
    border_focus = colors['background'],
    border_normal = colors['background'],
    border_width = 1
)

focus_on_window_activation = "smart"
auto_fullscreen = True

wmname = "LG3D"
