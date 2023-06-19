#!/usr/bin/env bash

OPEN_COMMAND="xdg-open"
EDIT_COMMAND="subl"
REMEMBER_PATH=true
PREV_PATH_FILE_NAME="prev_path"

ACTION_BROWSE="BROWSE"
ACTION_UP="UP"
ACTION_BACK="BACK"
ACTION_OPEN="OPEN"
ACTION_EDIT="EDIT"
ACTION_DELETE="DELETE"
ACTION_DELETE_CONFIRM="DELETE_CONFIRM"
ACTION_DELETE_CANCEL="DELETE_CANCEL"

ICON_PROMPT=""
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
    while read -r name; do
        icon="$ICON_FILE "
        if [ -d "$currentPath/$name" ]; then
            icon="$ICON_FOLDER "
        fi
        echo "$icon$name\0info\x1f${ACTION_BROWSE};$name;$currentPath"
    done
}

listFiles() {
    echo -en "\0message\x1f ${CUR_DIR}/\n"
    listLoc="/"
    if [ ! -z "$CUR_DIR" ]; then
        echo -en "$ICON_UP\0info\x1f${ACTION_UP};${ACTION_UP};${CUR_DIR}\n"
        listLoc=$CUR_DIR
    fi

    echo -en "$(ls --group-directories-first --color=never --almost-all $listLoc | buildEntry $CUR_DIR)"
}

init() {
    if [ $REMEMBER_PATH = true ] && [ -f "$PREV_PATH_FILE" ]; then
        CUR_DIR=$(cat $PREV_PATH_FILE)
        CUR_DIR=$(normalizeName $CUR_DIR)
    fi

    if [ -z "$CUR_DIR" ] || [ ! -d "$CUR_DIR" ]; then
        CUR_DIR="$HOME"
    fi

    listFiles
}

browse() {
    if [ -d "$PREV_PATH/$SELECTION" ]; then
        CUR_DIR="$PREV_PATH/$SELECTION"
        echo "$CUR_DIR" > $PREV_PATH_FILE
        listFiles

    else
        handleFile "$PREV_PATH/$SELECTION"        
    fi
}

up() {
    CUR_DIR=${PREV_PATH%/*}
    echo "$CUR_DIR" > $PREV_PATH_FILE
    listFiles
}

handleFile() {
    FILE="$1"
    echo -en "\0message\x1f ${FILE}\n"

    echo -en "$ICON_BACK back\0info\x1f${ACTION_BACK};${ACTION_BACK};${FILE}\n"
    echo -en "$ICON_OPEN open\0info\x1f${ACTION_OPEN};${ACTION_OPEN};${FILE}\n"
    echo -en "$ICON_EDIT edit\0info\x1f${ACTION_EDIT};${ACTION_EDIT};${FILE}\n"
    echo -en "$ICON_DELETE delete\0info\x1f${ACTION_DELETE};${ACTION_DELETE};${FILE}\n"
}

back() {
    CUR_DIR="${PREV_PATH%/*}"
    listFiles
}

open() {
    coproc ( ${OPEN_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
}

edit() {
    coproc ( ${EDIT_COMMAND} ${PREV_PATH}  > /dev/null  2>&1 )
}

delete() {
    echo -en "\0message\x1f $ICON_DELETE ${PREV_PATH}\n"
    echo -en "$ICON_CANCEL cancel\0info\x1f${ACTION_DELETE_CANCEL};${ACTION_DELETE_CANCEL};${PREV_PATH}\n"
    echo -en "$ICON_OK ok\0info\x1f${ACTION_DELETE_CONFIRM};${ACTION_DELETE_CONFIRM};${PREV_PATH}\n"
}

deleteCancel() {
    handleFile "${PREV_PATH}"
}

deleteConfirm() {
    rm "${PREV_PATH}"
    back
}

normalizeName() {
    path=$1
    if [ ! -f "$path" ] && [[ $path == */ ]]; then
        path="${path%/*}"
    fi
    echo "$path"
}

################################################################################
# main

################################################################################
PREV_PATH_FILE=$(readlink -f "$0")
PREV_PATH_FILE=$(dirname "$PREV_PATH_FILE")
PREV_PATH_FILE="$PREV_PATH_FILE/$PREV_PATH_FILE_NAME"

ACTION=$(echo $ROFI_INFO | cut -d ';' -f1)
SELECTION=$(echo $ROFI_INFO | cut -d ';' -f2)
PREV_PATH=$(echo $ROFI_INFO | cut -d ';' -f3)
PREV_PATH=$(normalizeName "$PREV_PATH")

echo -en "\0prompt\x1f$ICON_PROMPT\n"
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
