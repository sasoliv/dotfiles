#!/usr/bin/env sh

source ~/.local/bin/env.bash

LOC=$(readlink -f "$0")
LOC=$(dirname "$LOC")
rofi -show tv -modi "tv:$LOC/live-tv.py" -theme $LOC/theme.rasi
