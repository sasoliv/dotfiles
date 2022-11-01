#!/usr/bin/env sh

OPEN_COMMAND="xdg-open"
EDIT_COMMAND="subl"
REMEMBER_PATH=true

ACTION_BROWSE="BROWSE"
ACTION_UP="UP"
ACTION_BACK="BACK"
ACTION_OPEN="OPEN"
ACTION_EDIT="EDIT"
ACTION_DELETE="DELETE"
ACTION_DELETE_CONFIRM="DELETE_CONFIRM"
ACTION_DELETE_CANCEL="DELETE_CANCEL"

ICON_UP=""
ICON_BACK=""
ICON_OPEN=""
ICON_EDIT=""
ICON_DELETE=""
ICON_CANCEL=""
ICON_OK=""
ICON_FOLDER=""
ICON_FILE=" "

################################################################################
# functions
################################################################################

buildEntry(){
    currentPath=$1
    while read -r path; do
        icon="$ICON_FILE "
        label=$path
        if [[ $path == */ ]]; then
            icon="$ICON_FOLDER "
            label=${label%/*}
        fi
        echo "$icon$label\0info\x1f${ACTION_BROWSE};$path;$currentPath"
    done
}

listFiles() {
    echo -en "\0message\x1f${CUR_DIR}\n"

    if [ "$CUR_DIR" != "/" ]; then
        echo -en "$ICON_UP\0info\x1f${ACTION_UP};${ACTION_UP};${CUR_DIR}\n"
    fi

    echo -en "$(ls --group-directories-first --color=never --indicator-style=slash --almost-all $CUR_DIR | buildEntry $CUR_DIR)"
}

init() {
    if [ $REMEMBER_PATH = true ] && [ -f "$PREV_PATH_FILE" ]; then
        CUR_DIR=$(cat $PREV_PATH_FILE)
    fi

    if [ -z "$CUR_DIR" ] || [ ! -d "$CUR_DIR" ] || [ -L "$CUR_DIR" ]; then
        CUR_DIR="$HOME/"
    fi

    listFiles
}

browse() {
    if [[ $SELECTION == */ ]]; then
        CUR_DIR="$PREV_PATH$SELECTION"
        echo "$CUR_DIR" > $PREV_PATH_FILE
        listFiles

    else
        handleFile "$PREV_PATH$SELECTION"        
    fi
}

up() {
    CUR_DIR=${PREV_PATH%/*}
    CUR_DIR="${CUR_DIR%/*}/"
    echo "$CUR_DIR" > $PREV_PATH_FILE
    listFiles
}

handleFile() {
    FILE="$1"
    echo -en "\0message\x1f${FILE}\n"

    echo -en "$ICON_BACK back\0info\x1f${ACTION_BACK};${ACTION_BACK};${FILE}\n"
    echo -en "$ICON_OPEN open\0info\x1f${ACTION_OPEN};${ACTION_OPEN};${FILE}\n"
    echo -en "$ICON_EDIT edit\0info\x1f${ACTION_EDIT};${ACTION_EDIT};${FILE}\n"
    echo -en "$ICON_DELETE delete\0info\x1f${ACTION_DELETE};${ACTION_DELETE};${FILE}\n"
}

back() {
    CUR_DIR="${PREV_PATH%/*}/"
    listFiles
}

open() {
    coproc ( ${OPEN_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
}

edit() {
    coproc ( ${EDIT_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
}

delete() {
    echo -en "\0message\x1f$ICON_DELETE ${PREV_PATH}\n"
    echo -en "$ICON_CANCEL cancel\0info\x1f${ACTION_DELETE_CANCEL};${ACTION_DELETE_CANCEL};${PREV_PATH}\n"
    echo -en "$ICON_OK ok\0info\x1f${ACTION_DELETE_CONFIRM};${ACTION_DELETE_CONFIRM};${PREV_PATH}\n"
}

deleteCancel() {
    handleFile "${PREV_PATH}"
}

deleteConfirm() {
    rm "${PREV_PATH}"
}

################################################################################
# main
################################################################################

PREV_PATH_FILE=$XDG_CONFIG_HOME
if [ -z "$PREV_PATH_FILE" ]; then
    PREV_PATH_FILE="$HOME/.config"
fi
PREV_PATH_FILE="$PREV_PATH_FILE/rofi/file-browser/prev_path"

ACTION=$(echo $ROFI_INFO | cut -d ';' -f1)
SELECTION=$(echo $ROFI_INFO | cut -d ';' -f2)
PREV_PATH=$(echo $ROFI_INFO | cut -d ';' -f3)

echo -en "\0prompt\x1f\n"
echo -en "\0keep-selection\x1ffalse\n"

case $ACTION in
    $ACTION_BACK) back ;;
    $ACTION_OPEN) open ;;
    $ACTION_EDIT) edit ;;
    $ACTION_DELETE) delete ;;
    $ACTION_DELETE_CANCEL) deleteCancel ;;
    $ACTION_DELETE_CONFIRM) deleteConfirm ;;
    $ACTION_BROWSE) browse ;;
    $ACTION_UP) up ;;
    *) init ;;
esac
