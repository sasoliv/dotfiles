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

################################################################################
# functions
################################################################################

listFiles() {
    CUR_DIR_ESCAPED=$(echo "$CUR_DIR" | sed 's/\//\\\//g')

    echo -en "\0message\x1f${CUR_DIR}\n"

    if [ "$CUR_DIR" != "/" ]
    then
        echo -en "\0info\x1f${ACTION_UP};${CUR_DIR}\n"
    fi

    ENTRIES=$(ls --group-directories-first --color=never --indicator-style=slash --almost-all $CUR_DIR | grep --color=never -v -e '^\./$' | sed -e "s/\$/\\\\0info\\\\x1f${ACTION_BROWSE};${CUR_DIR_ESCAPED}/")
    echo -en "$ENTRIES"
}

init() {
    if [ $REMEMBER_PATH = true ] && [ -f "$PREV_PATH_FILE" ] 
    then
        CUR_DIR=$(cat $PREV_PATH_FILE)
    fi

    if [ -z "$CUR_DIR" ] || [ ! -d "$CUR_DIR" ] || [ -L "$CUR_DIR" ]
    then
        CUR_DIR="$HOME/"
    fi

    listFiles
}

browse() {
    if [[ $SELECTION == */ ]]    
    then
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

    echo -en " back\0info\x1f${ACTION_BACK};${FILE}\n"
    echo -en " open\0info\x1f${ACTION_OPEN};${FILE}\n"
    echo -en " edit\0info\x1f${ACTION_EDIT};${FILE}\n"
    echo -en " delete\0info\x1f${ACTION_DELETE};${FILE}\n"
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
    echo -en "\0message\x1f ${PREV_PATH}\n"
    echo -en " cancel\0info\x1f${ACTION_DELETE_CANCEL};${PREV_PATH}\n"
    echo -en " ok\0info\x1f${ACTION_DELETE_CONFIRM};${PREV_PATH}\n"
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
if [ -z "$PREV_PATH_FILE" ]
then
    PREV_PATH_FILE="$HOME/.config"
fi
PREV_PATH_FILE="$PREV_PATH_FILE/rofi/file-browser/prev_path"

SELECTION="$@"
ACTION=$(echo $ROFI_INFO | cut -d ';' -f1)
PREV_PATH=$(echo $ROFI_INFO | cut -d ';' -f2)

echo -en "\0prompt\x1f\n"
echo -en "\0keep-selection\x1ffalse\n"

case "$ACTION" in
    "$ACTION_BACK") back ;;
    "$ACTION_OPEN") open ;;
    "$ACTION_EDIT") edit ;;
    "$ACTION_DELETE") delete ;;
    "$ACTION_DELETE_CANCEL") deleteCancel ;;
    "$ACTION_DELETE_CONFIRM") deleteConfirm ;;
    "$ACTION_BROWSE") browse ;;
    "$ACTION_UP") up ;;
    *) init ;;
esac
