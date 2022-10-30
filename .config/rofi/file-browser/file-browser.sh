#!/usr/bin/env sh

OPEN_COMMAND="xdg-open"
EDIT_COMMAND="subl"
REMEMBER_PATH=true

ACTION_BROWSE="BROWSE"
ACTION_UP="UP"
ACTION_BACK="BACK"
ACTION_OPEN="OPEN"
ACTION_EDIT="EDIT"

PREV_PATH_FILE=$XDG_CONFIG_HOME
if [ -z "$PREV_PATH_FILE" ]
then
    PREV_PATH_FILE="$HOME/.config"
fi
PREV_PATH_FILE="$PREV_PATH_FILE/rofi/file-browser/prev_path"

SELECTION="$@"
ACTION=$(echo $ROFI_INFO | cut -d ';' -f1)
PREV_PATH=$(echo $ROFI_INFO | cut -d ';' -f2)

init() {
    if [ $REMEMBER_PATH = true ] && [ -f "$PREV_PATH_FILE" ] 
    then
        CUR_DIR=$(cat $PREV_PATH_FILE)
    fi

    if [ -z "$CUR_DIR" ]
    then
        CUR_DIR="$HOME/"
    fi
}

browse() {
    if [[ $SELECTION == */ ]]    
    then
        CUR_DIR="$PREV_PATH$SELECTION"
        echo "$CUR_DIR" > $PREV_PATH_FILE

    else
        handleFile "$PREV_PATH$SELECTION"
        exit 0
    fi
}

up() {
    CUR_DIR=${PREV_PATH%/*}
    CUR_DIR="${CUR_DIR%/*}/"
    echo "$CUR_DIR" > $PREV_PATH_FILE
}

handleFile() {
    FILE=$1
    FILE_ESCAPED=$(echo "$FILE" | sed 's/\//\\\//g')    
    echo -en "\0message\x1f${FILE}\n"

    echo -en " back\0info\x1f${ACTION_BACK};${FILE}\n"
    echo -en " open\0info\x1f${ACTION_OPEN};${FILE}\n"
    echo -en " edit\0info\x1f${ACTION_EDIT};${FILE}\n"
}

back() {
    CUR_DIR="${PREV_PATH%/*}/"
}

open() {
    coproc ( ${OPEN_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
    exit 0
}

edit() {
    coproc ( ${EDIT_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
    exit 0
}

echo -en "\0prompt\x1f\n"
echo -en "\0keep-selection\x1ffalse\n"

case "$ACTION" in
    "$ACTION_BACK") back ;;
    "$ACTION_OPEN") open ;;
    "$ACTION_EDIT") edit ;;
    "$ACTION_BROWSE") browse ;;
    "$ACTION_UP") up ;;
    *) init ;;
esac

CUR_DIR_ESCAPED=$(echo "$CUR_DIR" | sed 's/\//\\\//g')

echo -en "\0message\x1f${CUR_DIR}\n"

if [ "$CUR_DIR" != "/" ]
then
    echo -en "\0info\x1f${ACTION_UP};${CUR_DIR}\n"
fi

ENTRIES=$(ls --group-directories-first --color=never --indicator-style=slash --almost-all $CUR_DIR | grep --color=never -v -e '^\./$' | sed -e "s/\$/\\\\0info\\\\x1f${ACTION_BROWSE};${CUR_DIR_ESCAPED}/")
echo -en "$ENTRIES"
