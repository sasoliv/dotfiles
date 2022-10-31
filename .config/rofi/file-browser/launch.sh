#!/usr/bin/env bash

CONFIG=$XDG_CONFIG_HOME
if [ -z "$CONFIG" ]
then
    CONFIG="$HOME/.config"
fi
CONFIG="$CONFIG/rofi/file-browser"

rofi -show fb -modi "fb:$CONFIG/file-browser.sh" -theme "$CONFIG/theme.rasi"