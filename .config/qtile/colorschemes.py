import json
import os

import pywal

from settings import enable_pywal, random_wal, wallpaper_dir


def randomize_pywal(wal_dir):
    image = pywal.image.get(wal_dir)
    pywal.wallpaper.change(image)
    return pywal.colors.get(image)


nord = dict()
gruvbox = dict()
onedark = dict()
current_scheme = dict()

properties = [
    "foreground",
    "background",
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "black_alt",
    "red_alt",
    "green_alt",
    "yellow_alt",
    "blue_alt",
    "magenta_alt",
    "cyan_alt",
    "white_alt",
]


nord_colors = [
    "#d8dee9",
    "#2E3440",
    "#3b4252",
    "#bf616a",
    "#a3be8c",
    "#ebcb8b",
    "#81a1c1",
    "#b48ead",
    "#88c0d0",
    "#e5e9f0",
    "#373e4d",
    "#94545d",
    "#809575",
    "#b29e75",
    "#68809a",
    "#8c738c",
    "#6d96a5",
    "#aeb3bb",
]
gruvbox_colors = [
    "#ebdbb2",
    "#272727",
    "#272727",
    "#cc231c",
    "#989719",
    "#d79920",
    "#448488",
    "#b16185",
    "#689d69",
    "#a89983",
    "#928373",
    "#fb4833",
    "#b8ba25",
    "#fabc2e",
    "#83a597",
    "#d3859a",
    "#8ec07b",
    "#ebdbb2",
]

onedark_colors = [
    "#abb2bf",
    "#282c34",
    "#2c323c",
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#5c6370",
    "#3e4452",
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#abb2bf",
]

if enable_pywal:
    if random_wal:
        data = randomize_pywal(wallpaper_dir)
    else:
        file = os.path.expanduser("~/.cache/wal/colors.json")
        with open(file) as f:
            data = json.load(f)

    current_scheme_colors = [
        data["special"]["foreground"],
        data["special"]["background"],
        data["colors"]["color0"],
        data["colors"]["color1"],
        data["colors"]["color2"],
        data["colors"]["color3"],
        data["colors"]["color4"],
        data["colors"]["color5"],
        data["colors"]["color6"],
        data["colors"]["color7"],
        data["colors"]["color8"],
        data["colors"]["color9"],
        data["colors"]["color10"],
        data["colors"]["color11"],
        data["colors"]["color12"],
        data["colors"]["color13"],
        data["colors"]["color14"],
        data["colors"]["color15"],
    ]

for num in range(len(properties)):
    tmp = properties[num]
    gruvbox[tmp] = gruvbox_colors[num]
    nord[tmp] = nord_colors[num]
    onedark[tmp] = onedark_colors[num]
    if enable_pywal:
        current_scheme[tmp] = current_scheme_colors[num]
