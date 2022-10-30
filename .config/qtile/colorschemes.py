import json
import os
from typing import List

import pywal

from settings import enable_pywal, random_wal, wallpaper_dir


def randomize_pywal(wal_dir):
    image = pywal.image.get(wal_dir)
    pywal.wallpaper.change(image)
    return pywal.colors.get(image)


colors = {
    "nord": [
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
    ],
    "gruvbox": [
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
    ],
    "onedark": [
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
    ],
    "catppuccin-mocha": [
        "#CDD6F4",
        "#1E1E2E",
        "#45475A",
        "#F38BA8",
        "#A6E3A1",
        "#F9E2AF",
        "#89B4FA",
        "#F5C2E7",
        "#94E2D5",
        "#BAC2DE",
        "#585B70",
        "#F38BA8",
        "#A6E3A1",
        "#F9E2AF",
        "#89B4FA",
        "#F5C2E7",
        "#94E2D5",
        "#A6ADC8",
    ],
    "catppuccin-macchiato": [
        "#CAD3F5",
        "#24273A",
        "#494D64",
        "#ED8796",
        "#A6DA95",
        "#EED49F",
        "#8AADF4",
        "#F5BDE6",
        "#8BD5CA",
        "#B8C0E0",
        "#5B6078",
        "#ED8796",
        "#A6DA95",
        "#EED49F",
        "#8AADF4",
        "#F5BDE6",
        "#8BD5CA",
        "#A5ADCB",
    ],
}


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


def get_colorscheme(name: str = None):
    if name is None and not enable_pywal:
        raise TypeError("missing name parameter for colorscheme generation")

    colorscheme_colors = None
    if enable_pywal:
        colorscheme_colors = current_scheme_colors
    else:
        if name not in colors:
            raise TypeError("missing valid name for colorscheme")
        colorscheme_colors = colors[name]

    colorscheme = {}
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
    for i, color in enumerate(colorscheme_colors):
        colorscheme[properties[i]] = color

    return colorscheme
