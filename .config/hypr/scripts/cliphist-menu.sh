#!/usr/bin/env bash

# Run rofi with custom keybind overrides: 
# - Alt+Delete to delete the highlighted entry
# - Alt+Shift+Delete to wipe the entire history clean
chosen=$(cliphist list | rofi -dmenu \
    -p "Clipboard" \
    -theme ~/.config/rofi/launchers/type-6/style-1.rasi \
    -kb-custom-1 "Alt+Delete" \
    -kb-custom-2 "Alt+Shift+Delete")

exit_code=$?

# If user hit Alt+Delete (Custom 1)
if [ "$exit_code" -eq 10 ]; then
    echo "$chosen" | cliphist delete
    notify-send "Clipboard" "Deleted selected entry"
    exec "$0" # Relaunch menu smoothly

# If user hit Alt+Shift+Delete (Custom 2)
elif [ "$exit_code" -eq 11 ]; then
    cliphist wipe
    notify-send "Clipboard" "Cleared entire clipboard history"

# If user hit Enter (Normal selection)
elif [ "$exit_code" -eq 0 ] && [ -n "$chosen" ]; then
    echo "$chosen" | cliphist decode | wl-copy
fi