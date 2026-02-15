#!/bin/bash
LOCK_FILE="/tmp/waybar-disabled"

if [ -f "$LOCK_FILE" ]; then
    rm "$LOCK_FILE"
    notify-send "Waybar" "Auto-hide Enabled" -t 2000
else
    touch "$LOCK_FILE"
    # Force hide immediately
    killall -SIGUSR1 waybar
    notify-send "Waybar" "Hidden (Manual Override)" -t 2000
fi
