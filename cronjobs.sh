#!/bin/bash

# Determine the directory where this script is located
# This allows the scheduled cron job to correctly locate the selected script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Use Zenity to allow the user to select which script to schedule
# The selected script name is stored in the variable "job"
job=$(zenity --list \
    --title="Select Job" \
    --column="Script" \
    "create_backup.sh" \
    "update_packages.sh" \
    "update_network.sh")

# If no job is selected, exit the script
[[ -z "$job" ]] && exit 1

# Use Zenity calendar to select a date
# The selected date is stored in MM DD YYYY format
date=$(zenity --calendar --date-format="%m %d %Y")

# If no date is selected, exit the script
[[ -z "$date" ]] && exit 1

# Prompt the user to enter a time in 12-hour format (HH:MM)
# The entered time is stored in the variable "time"
time=$(zenity --entry --text="Enter time (HH:MM)")

# If no time is entered, exit the script
[[ -z "$time" ]] && exit 1

# Prompt the user to select AM or PM
# The selection is stored in the variable "ampm"
ampm=$(zenity --list --column="Choice" "AM" "PM")

# If no AM/PM option is selected, exit the script
[[ -z "$ampm" ]] && exit 1

# Split the entered time into hours (hh) and minutes (mm)
# Convert the time from 12-hour format to 24-hour format
IFS=: read hh mm <<< "$time"
if [[ "$ampm" == "PM" && "$hh" != "12" ]]; then
    hh=$((10#$hh + 12))
elif [[ "$ampm" == "AM" && "$hh" == "12" ]]; then
    hh=0
fi

# Extract month, day, and year from the selected date
read month day year <<< "$date"

# Use Zenity to select how often the cron job should run
# The selected schedule is stored in the variable "schedule"
schedule=$(zenity --list --column="Schedule" \
    "Daily" \
    "Weekly" \
    "Monthly" \
    "Yearly")

# Use a case statement to build the appropriate cron syntax
# based on the user's selected schedule
case "$schedule" in
    Daily) cron="$mm $hh * * *" ;;
    Weekly) cron="$mm $hh * * 1" ;;
    Monthly) cron="$mm $hh $day * *" ;;
    Yearly) cron="$mm $hh $day $month *" ;;
    *) exit 1 ;;
esac

# Add the cron job to the user's crontab
# DISPLAY and XAUTHORITY are included so GUI applications (Zenity)
# can display correctly when run by cron
( crontab -l 2>/dev/null; \
  echo "$cron DISPLAY=:0 XAUTHORITY=/home/$USER/.Xauthority /bin/bash $SCRIPT_DIR/$job" ) | crontab -

# Display confirmation message to the user
zenity --info --text="Cron job scheduled!"
