#!/usr/bin/env sh

LOC=$(readlink -f "$0")
LOC=$(dirname "$LOC")
rofi -show drun -theme "$LOC/theme.rasi"
