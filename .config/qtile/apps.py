from settings import enable_pywal, random_wal

terminal = "kitty -1"
browser = "brave"
fm = "thunar"
guake_term = "kitty"
entertainment = "stremio"
chat = "telegram-desktop"
screenshot = "flameshot gui"
# calculator = "gnome-calculator"
calculator = "qalculate-gtk"
editor = "kitty -e nvim"
task_manager = "xfce4-taskmanager"
screen_locker = "betterlockscreen -l"

startup_apps = [
    "lxsession &",
    "picom &",
    "killall redshift 2> /dev/null || redshift -l 8:38 -t 6500K:3500K &",
    "nm-applet &",
    "xset b off",
]

if not random_wal and enable_pywal:
    startup_apps.append("wal -R")
elif not enable_pywal:
    startup_apps.append("nitrogen --restore")
