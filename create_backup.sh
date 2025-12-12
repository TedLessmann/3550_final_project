#!/bin/bash

# Use Zenity to prompt the user to select the SOURCE directory to back up
# The selected directory path is stored in the variable "source_dir"
source_dir=$(zenity --file-selection \
    --directory \
    --title="Select the SOURCE directory to back up")

# If the user cancels the dialog or no directory is selected, exit the script
if [[ -z "$source_dir" ]]; then
    zenity --error --text="No source directory selected. Backup cancelled."
    exit 1
fi

# Use Zenity to prompt the user to select the DESTINATION directory
# The selected directory path is stored in the variable "dest_dir"
dest_dir=$(zenity --file-selection \
    --directory \
    --title="Select the DESTINATION directory for the backup")

# If the user cancels the dialog or no directory is selected, exit the script
if [[ -z "$dest_dir" ]]; then
    zenity --error --text="No destination directory selected. Backup cancelled."
    exit 1
fi

# Generate a timestamp to uniquely identify the backup file
timestamp=$(date +"%Y%m%d-%H%M%S")

# Construct the backup filename using the source directory name and timestamp
backup_name="backup-$(basename "$source_dir")-$timestamp.tar.gz"

# Construct the full path where the backup will be saved
backup_path="$dest_dir/$backup_name"

# Create a compressed tar archive of the source directory
# -c creates the archive
# -z compresses it using gzip
# -f specifies the output file name
# -C changes to the parent directory so only the folder is archived
if tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"; then
    # If the backup succeeds, notify the user with Zenity
    zenity --info --text="Backup created successfully:\n$backup_path"
else
    # If the backup fails, notify the user with Zenity
    zenity --error --text="Backup failed."
fi
