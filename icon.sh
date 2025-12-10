#!/bin/bash

script=$(zenity --file-selection --title="Select script")
icon=$(zenity --file-selection --title="Select icon image")
name=$(zenity --entry --title="Icon Name")

desktop="$HOME/Desktop/${name// /_}.desktop"

echo "[Desktop Entry]" > "$desktop"
echo "Type=Application" >> "$desktop"
echo "Name=$name" >> "$desktop"
echo "Exec=/bin/bash $script" >> "$desktop"
echo "Icon=$icon" >> "$desktop"
echo "Terminal=true" >> "$desktop"

chmod +x "$desktop"

zenity --info --text="Desktop icon created"
