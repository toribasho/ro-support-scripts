#!/bin/bash

PREV_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
hyprctl dispatch focuswindow class:arcadia-launcher.exe
sleep 0.1
ydotool key 28:1 28:0
sleep 0.3
ydotool key 28:1 28:0
sleep 0.3
ydotool key 28:1 28:0
sleep 0.3
hyprctl dispatch focuswindow "address:$PREV_WINDOW"
