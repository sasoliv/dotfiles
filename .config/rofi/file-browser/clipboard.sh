#!/usr/bin/env sh

OPEN_COMMAND="xdg-open"
EDIT_COMMAND="subl"
PREV_PATH_FILE_NAME="prev_path"
KEEP_TEMP_FILES=false

OK=" ok"
CANCEL=" cancel"

CONFIG=$XDG_CONFIG_HOME
if [ -z "$CONFIG" ]
then
    CONFIG="$HOME/.config"    
fi
CONFIG="$CONFIG/rofi/file-browser"
PREV_PATH_FILE="$CONFIG/$PREV_PATH_FILE_NAME"

main(){
    clip=$(copyq clipboard)
    if [ -f "$clip" ]; then
        handleFile "$clip"
    elif [ -d "$clip" ]; then
        handleFolder "$clip"
    else
        fallback "$clip"
    fi
}

handleFile() {
    path="$1"
    
    folder="${path%/*}/"
    file=$(basename $path)

    echo "$folder" > $PREV_PATH_FILE
    export ROFI_INFO="BROWSE;$file;$folder"

    $CONFIG/launch.sh
}

handleFolder() {
    path="$1"
    echo "$path" > $PREV_PATH_FILE
    $CONFIG/launch.sh
}

fallback() {
    content=$1
    action=$(echo -en "$CANCEL\n$OK" \
        | rofi -dmenu -theme "$CONFIG/theme-clipboard.rasi" \
        -p "$PROMPT" \
        -mesg "Clipboard content is neither a file nor a folder. Check value?" \
    )
    if [ -z "$action" ] || [ "$action" == "$CANCEL" ]; then
        exit 0
    fi

    tempFile=$(mktemp /tmp/clipboar-XXX)
    echo "$content" > $tempFile
    $EDIT_COMMAND $tempFile

    if [ $KEEP_TEMP_FILES = false ]; then
        rm $tempFile
    fi
}

main