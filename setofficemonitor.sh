#!/bin/bash

if [ $1 == "on" ]; then
     xrandr --output VGA-1 --above LVDS-1 --auto
elif [ $1 == "off" ]; then
     xrandr --output VGA-1 --off --auto
fi
~/.fehbg
