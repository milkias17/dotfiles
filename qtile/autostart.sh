#!/bin/bash
picom --experimental-backends &
redshift -l 8:38 -t 6500K:3500K &
xsettingsd &
lxsession &
nm-applet &
xset b off
nitrogen --restore
