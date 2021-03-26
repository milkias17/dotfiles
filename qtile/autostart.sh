#!/bin/bash
picom &
killall redshift 2> /dev/null || redshift -l 8:38 -t 6500K:3500K &
lxsession &
nm-applet &
xset b off
nitrogen --restore
