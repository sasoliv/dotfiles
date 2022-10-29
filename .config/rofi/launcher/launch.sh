#!/bin/sh

CONFIG=$XDG_CONFIG_HOME
if [ -z "$CONFIG" ]
then
    CONFIG="$HOME/.config"
fi
CONFIG="$CONFIG/rofi/launcher"

rofi -show drun -theme "$CONFIG/theme.rasi"
