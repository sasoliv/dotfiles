#!/usr/bin/env bash

OPEN_COMMAND="xdg-open"
EDIT_COMMAND="subl"
PREV_PATH_FILE_NAME="prev_path"
KEEP_TEMP_FILES=false

PROMPT=""
ICON_FOLDER=""
ICON_FILE=""

OPEN=" open"
EDIT=" edit"
BROWSE=" browse"
VIEW=" view in editor"

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
    clip="$(copyq read)"

    path=$(echo $clip | sed -e 's/^[[:space:]]*//')
    pathNormalized=${path/\~/$HOME}

    options=""
    lineBreak=""
    icon=""
    showMessage=false
    if [ -f "$pathNormalized" ]; then
        options="$OPEN\n$EDIT\n$BROWSE"
        lineBreak="\n"
        icon="$ICON_FILE"
        showMessage=true
    elif [ -d "$pathNormalized" ]; then
        options="$OPEN\n$BROWSE"
        lineBreak="\n"
        icon="$ICON_FOLDER"
        showMessage=true
    fi

    options="$options$lineBreak$VIEW"

    action=""
    if [ $showMessage == true ];then
        action=$(echo -en "$options" \
            | rofi -dmenu -theme "$CONFIG/theme.rasi" \
            -p "$PROMPT" \
            -mesg "$icon $path" \
        )
    else
        action=$(echo -en "$options" \
            | rofi -dmenu -theme "$CONFIG/theme.rasi" \
            -p "$PROMPT" \
        )
    fi

    case $action in
        $OPEN) $OPEN_COMMAND "$pathNormalized" ;;
        $EDIT) $EDIT_COMMAND "$pathNormalized" ;;
        $BROWSE) browse "$pathNormalized" ;;
        $VIEW) view "$clip" ;;
        *) ;;
    esac
    
}

browse() {
    path=$1
    if [ -f "$path" ]; then
        handleFile $path
    elif [ -d "$path" ]; then
        handleFolder $path
    fi
}

handleFile() {
    path="$1"
    
    folder="${path%/*}"
    file=$(basename $path)

    echo "$folder" > $PREV_PATH_FILE
    export ROFI_INFO="BROWSE;$file;$folder"

    $CONFIG/launch.sh
}

handleFolder() {
    path="$1"

    while [[ $path == */ ]]
    do
       path="${path%/*}"
    done

    parent="${path%/*}"
    folder=$(basename $path)

    echo "$path" > $PREV_PATH_FILE
    export ROFI_INFO="BROWSE;$folder;$parent"
    $CONFIG/launch.sh
}

view() {
    content=$1

    if [ $KEEP_TEMP_FILES = false ]; then
        rm -rf /tmp/clipboar-*
    fi

    tempFile=$(mktemp /tmp/clipboar-XXX)
    echo "$content" > $tempFile
    $EDIT_COMMAND $tempFile
}

main