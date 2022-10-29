#!/usr/bin/env sh

OPEN_COMMAND="xdg-open"
EDIT_COMMAND="subl"
REMEMBER_PATH=true

ACTION_BROWSE="BROWSE"
ACTION_OPEN="OPEN"
ACTION_EDIT="EDIT"
ACTION_CANCEL="CANCEL"

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
    if [ "$SELECTION" == "../" ]
    then
        CUR_DIR=${PREV_PATH%/*}
        CUR_DIR="${CUR_DIR%/*}/"
        echo "$CUR_DIR" > $PREV_PATH_FILE

    elif [[ $SELECTION == */ ]]    
    then
        CUR_DIR="$PREV_PATH$SELECTION"
        echo "$CUR_DIR" > $PREV_PATH_FILE

    else
        handleFile "$PREV_PATH$SELECTION"
        exit 0
    fi
}

handleFile() {
    FILE=$1
    FILE_ESCAPED=$(echo "$FILE" | sed 's/\//\\\//g')
    echo -en "\0prompt\x1f\n"
    echo -en "\0message\x1f${FILE}\n"

    echo -en " open\0info\x1f${ACTION_OPEN};${FILE}\n"
    echo -en " edit\0info\x1f${ACTION_EDIT};${FILE}\n"
    echo -en " cancel\0info\x1f${ACTION_CANCEL};${FILE}\n"
}

open() {
    coproc ( ${OPEN_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
    exit 0
}

edit() {
    coproc ( ${EDIT_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
    exit 0
}

cancel() {
    CUR_DIR="${PREV_PATH%/*}/"
}

echo -en "\0keep-selection\x1ffalse\n"

case "$ACTION" in
  "$ACTION_OPEN")
    open
    ;;
  "$ACTION_EDIT")
    edit
    ;;
  "$ACTION_CANCEL")
    cancel
    ;;
   "$ACTION_BROWSE")
    browse
    ;;
  *)
    init
    ;;
esac

CUR_DIR_ESCAPED=$(echo "$CUR_DIR" | sed 's/\//\\\//g')

echo -en "\0prompt\x1f\n"
echo -en "\0message\x1f${CUR_DIR}\n"

ENTRIES=$(ls --group-directories-first --color=never --indicator-style=slash -a $CUR_DIR | grep --color=never -v -e '^\./$' | sed -e "s/\$/\\\\0info\\\\x1f${ACTION_BROWSE};${CUR_DIR_ESCAPED}/")

echo -en "$ENTRIES"
