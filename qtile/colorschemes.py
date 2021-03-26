nord = dict()
gruvbox = dict()

properties = ['foreground', 'background', 'black',
              'red', 'green', 'yellow',
              'blue', 'magenta', 'cyan',
              'white', 'black_alt', 'red_alt',
              'green_alt', 'yellow_alt', 'blue_alt',
              'magenta_alt', 'cyan_alt', 'white_alt'
              ]


nord_colors = [ 
    "#d8dee9", "#2e3440", "#3b4252",
    "#bf616a", "#a3be8c", "#ebcb8b",
    "#81a1c1", "#b48ead", "#88c0d0",
    "#e5e9f0", "#373e4d", "#94545d",
    "#809575", "#b29e75", "#68809a", 
    "#8c738c", "#6d96a5", "#aeb3bb" 
]
gruvbox_colors = [
    '#ebdbb2', "#272727", "#272727",
    "#cc231c", "#989719", "#d79920",
    "#448488", "#b16185", "#689d69",
    "#a89983", "#928373", "#fb4833",
    "#b8ba25", "#fabc2e", "#83a597",
    "#d3859a", "#8ec07b", "#ebdbb2"
]

for num in range(len(properties)):
    tmp = properties[num]
    gruvbox[tmp] = gruvbox_colors[num]
    nord[tmp] = nord_colors[num]

