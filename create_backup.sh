#!/bin/bash

# Select a source directory or
# Use Zenity to select a source directory
source_dir=$(zenity --file-selection --directory --title="Select the SOURCE directory to back up")

# Select the destination folder
# Use Zenity to select the destination folder
dest_dir=$(zenity --file-selection --directory --title="Select the DESTINATION directory")

# If using Zeinty check if the user canceled the dialog
if [[ -z "$source_dir" || -z "$dest_dir" ]]; then
    zenity --error --text="Backup cancelled. No directory selected."
    exit 1
fi

# Create a tarball of the source folder and backup
timestamp=$(date +"%Y%m%d-%H%M%S")
backup_name="backup-$(basename "$source_dir")-$timestamp.tar.gz"
backup_path="$dest_dir/$backup_name"

tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"

# If using Zenity display the success or failure of the backup
if [[ $? -eq 0 ]]; then
    zenity --info --text="Backup created successfully:\n$backup_path"
else
    zenity --error --text="Backup failed."
fi


if tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"; then
    zenity --info --text="Backup created successfully:\n$backup_path"
else
    zenity --error --text="Backup failed."
fi
