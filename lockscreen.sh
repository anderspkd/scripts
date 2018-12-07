#!/usr/bin/env bash

# 1) Take screenshot
# 2) Blur screenshot
# 3) Run i3lock with blurred screenshot as the background
#
# If run as ./lockscreen 1, then screen is not blacked out.

IMGNAME='/tmp/lockimg.png'

scrot -z "$IMGNAME"
convert -blur 0x7 "$IMGNAME" "$IMGNAME"
i3lock -i "$IMGNAME"

if [ "$1" == "1" ]; then
    sleep 1 && xset dpms force off
fi
