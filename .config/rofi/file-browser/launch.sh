#!/usr/bin/env sh

CONFIG=$XDG_CONFIG_HOME
if [ -z "$CONFIG" ]
then
    CONFIG="$HOME/.config"
fi
CONFIG="$CONFIG/rofi/file-browser"

rofi -show fb -modes "fb:$CONFIG/file-browser.sh"