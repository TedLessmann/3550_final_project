#!/bin/bash

# Use Zenity to prompt the user to select a script file to run
# The selected script path is stored in the variable "script"
script=$(zenity --file-selection --title="Select script")

# Use Zenity to prompt the user to select an image file to use as the icon
# The selected image path is stored in the variable "icon"
icon=$(zenity --file-selection --title="Select icon image")

# Use Zenity to prompt the user to enter a name for the desktop icon
# The entered name is stored in the variable "name"
name=$(zenity --entry --title="Icon Name")

# Define the path for the .desktop file on the user's Desktop
# Any spaces in the name are replaced with underscores
desktop="$HOME/Desktop/${name// /_}.desktop"

# Create the .desktop file and write its required contents
# The first line uses > to create the file
# The following lines use >> to append to the file
echo "[Desktop Entry]" > "$desktop"
echo "Type=Application" >> "$desktop"
echo "Name=$name" >> "$desktop"
echo "Exec=/bin/bash $script" >> "$desktop"
echo "Icon=$icon" >> "$desktop"
echo "Terminal=true" >> "$desktop"

# Make the .desktop file executable so it can be launched
chmod +x "$desktop"

# Use Zenity to notify the user that the desktop icon was created successfully
zenity --info --text="Desktop icon created"
