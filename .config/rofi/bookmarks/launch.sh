#!/usr/bin/env sh

LOC=$(readlink -f "$0")
LOC=$(dirname "$LOC")
rofi -show bookmarks -modi "bookmarks:$LOC/bookmarks.py" -theme $LOC/theme.rasi