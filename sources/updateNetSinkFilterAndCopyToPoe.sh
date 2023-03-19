#!/usr/bin/env sh

poeFiltersFolder="/run/media/saso/M2/SteamLibrary/steamapps/compatdata/238960/pfx/drive_c/users/steamuser/My Documents/My Games/Path of Exile/"
refFolder=$(pwd)
gitFolder="$refFolder/NeverSink-Filter"

cd "$gitFolder"
echo "pulling..."
git pull
echo ""

echo "##########################################################################################"
echo "files to copy:"
echo ""
exa -la *.filter
echo ""

echo "##########################################################################################"
echo "filters before copy:"
echo ""
cd "$poeFiltersFolder"
exa -la *.filter
echo ""

echo "##########################################################################################"
echo "copying..."
cd "$gitFolder"
cp *.filter /run/media/saso/M2/SteamLibrary/steamapps/compatdata/238960/pfx/drive_c/users/steamuser/My\ Documents/My\ Games/Path\ of\ Exile/
echo ""

echo "##########################################################################################"
echo "filters after copy:"
cd "$poeFiltersFolder"
exa -la *.filter

cd "$refFolder"
