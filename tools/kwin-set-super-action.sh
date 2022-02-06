
if [ "$#" -ne 1 ]; then
    echo "check the trigger UUID in:"
    echo "    ~/.config/khotkeysrc"
    echo ""
    echo "include curly brackets. example:"
    echo "    $0 {e94fa02c-63bf-4c0e-97c5-8deccd9be02f}"
    exit 1
fi

kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.kglobalaccel,/component/khotkeys,org.kde.kglobalaccel.Component,invokeShortcut,$1"
qdbus org.kde.KWin /KWin reconfigure
