#!/bin/sh

loc=$(dirname ${BASH_SOURCE[0]})
rofi -show drun -theme "$loc/theme.rasi"
