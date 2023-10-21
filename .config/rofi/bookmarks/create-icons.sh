#!/usr/bin/env sh

FAVICONS_DB="$HOME/.config/BraveSoftware/Brave-Browser/Default/Favicons"
FAVICONS_DB_BCK="$FAVICONS_DB.bck"
ICONS_TARGET_LOCATION="$HOME/.local/share/icons/hicolor/16x16/apps"
ICON_PREFIX="rofi-bookmarks-"

createIcon() {
    domain=$1
    iconPath=$2

    sqlite3 "$FAVICONS_DB_BCK" "select quote(b.image_data) from favicons f inner join favicon_bitmaps b on f.id = b.icon_id where f.url like '%$domain%' LIMIT 1;" \
        | cut -d\' -f2 \
        | xxd -r -p > $iconPath
}

handleBookmark() {
    bookmark=$1
    id=$(echo $bookmark | cut -d ';' -f1)
    domain=$(echo $bookmark | cut -d ';' -f2)
    iconPath="${ICONS_TARGET_LOCATION}/${ICON_PREFIX}$id.png"

    createIcon $domain $iconPath
    img=$(cat $iconPath)
    if [ -z "$img" ]; then
        newDomain=$(echo "$domain" | cut -d '/' -f3)
        createIcon $newDomain $iconPath
    fi
    img=$(cat $iconPath)
    if [ -z "$img" ]; then
        newDomain2=$(echo "$newDomain" | cut -d '.' -f1)
        if [ "$newDomain2" = "www" ]; then
            newDomain2=$(echo "$newDomain" | cut -d '.' -f2)
        fi
        createIcon $newDomain2 $iconPath
    fi

    img=$(cat $iconPath)
    if [ -z "$img" ]; then
        echo "no favicon for $bookmark"
        rm $iconPath
    else
        echo "icon created: $iconPath"
    fi
}

cp $FAVICONS_DB $FAVICONS_DB_BCK

bookmarks=$(./get-urls.py)

for bookmark in $bookmarks
do
    handleBookmark $bookmark
done

#ids=$(sqlite3 "$FAVICONS_DB_BCK" "select b.icon_id from favicon_bitmaps b on f.id = b.icon_id;")
    #sqlite3 "$FAVICONS_DB.bck" "select quote(b.image_data) from favicon_bitmaps b on f.id = b.icon_id where f.url like '%myaccount%';"

#| cut -d\' -f2 \
#| xxd -r -p > xxx.png
