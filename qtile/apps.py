from settings import random_wal, enable_pywal

terminal = "kitty -1"
browser = "brave"
fm = "thunar"
guake_term = "kitty"
entertainment = "kodi"
chat = "telegram-desktop"
screenshot = "flameshot gui"
calculator = "gnome-calculator"
screen_locker = "betterlockscreen -l"
editor = "kitty -e nvim"
task_manager = "xfce4-taskmanager"

startup_apps = [
    "picom &",
    "killall redshift 2> /dev/null || redshift -l 8:38 -t 6500K:3500K &",
    "lxsession &",
    "nm-applet &",
    "xset b off",
]

if not random_wal and enable_pywal:
    startup_apps.append("wal -R")
elif not enable_pywal:
    startup_apps.append("nitrogen --restore")
