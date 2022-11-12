#!/usr/bin/env bash

loc=$(dirname ${BASH_SOURCE[0]})
rofi -show fb -modi "fb:$loc/file-browser.sh" -theme "$loc/theme.rasi"