#!/usr/bin/env sh

LOC=$(readlink -f "$0")
LOC=$(dirname "$LOC")
rofi -show fb -modi "fb:$LOC/file-browser.sh" -theme "$LOC/theme.rasi"