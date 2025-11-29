#!/usr/bin/env sh

poeFiltersFolder="/run/media/saso/M2/SteamLibrary/steamapps/compatdata/2694490/pfx/drive_c/users/steamuser/My Documents/My Games/Path of Exile 2/"
refFolder=$(pwd)
gitFolder="$refFolder/NeverSink-Filter-for-PoE2"

cd "$gitFolder"
echo "pulling..."
git pull
echo ""

echo "##########################################################################################"
echo "files to copy:"
echo ""
eza -la *.filter
echo ""

echo "##########################################################################################"
echo "filters before copy:"
echo ""
cd "$poeFiltersFolder"
eza -la *.filter
echo ""

echo "##########################################################################################"
echo "copying..."
cd "$gitFolder"
cp *.filter /run/media/saso/M2/SteamLibrary/steamapps/compatdata/2694490/pfx/drive_c/users/steamuser/My\ Documents/My\ Games/Path\ of\ Exile\ 2/
echo ""

echo "##########################################################################################"
echo "filters after copy:"
cd "$poeFiltersFolder"
eza -la *.filter

cd "$refFolder"
