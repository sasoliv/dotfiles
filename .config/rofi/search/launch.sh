#!/usr/bin/env bash

LOC=$(readlink -f "$0")
LOC=$(dirname "$LOC")
CONFIG_FILE="$LOC/config.json"
BROWSER="brave"

options=$($LOC/search.py "$CONFIG_FILE" list-services)
service=$(echo -en "$options" | rofi -dmenu -p " " -mesg 'search on' -theme $LOC/theme.rasi)

if [ ! -z "$service" ]
then
    message=$($LOC/search.py "$CONFIG_FILE" get-message "$service")
    input=$(echo '' | rofi -dmenu -p " " -mesg "$message" -theme $LOC/theme.rasi)
    if [ ! -z "$input" ]
    then
        url=$($LOC/search.py "$CONFIG_FILE" build-url "$service" "$input")
        $BROWSER "$url"
    fi
fi
