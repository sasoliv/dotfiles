#!/usr/bin/env bash

TERMINAL_EMULATOR="kitty"
LOCATIONS="~\n~/Desktop\n~/.config"

LOC=$(readlink -f "$0")
LOC=$(dirname "$LOC")

openTerminal() {
    selection=$1
    if [ ! -z "$selection" ]
    then
        selection=${selection/\~/$HOME}
        $TERMINAL_EMULATOR "$selection"
    fi
}

selection=$(echo -e "$LOCATIONS" | rofi -dmenu -p " " -mesg 'open terminal at' -theme $LOC/theme.rasi)
openTerminal $selection