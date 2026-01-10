#!/bin/bash


hyprctl dispatch sendshortcut , enter, class:arcadia-launcher.exe
sleep 0.3
hyprctl dispatch sendshortcut , s, class:arcadia-launcher.exe
sleep 2.4
hyprctl dispatch sendshortcut , s, class:arcadia-launcher.exe
sleep 0.05
hyprctl dispatch sendshortcut , a, class:arcadia-launcher.exe
sleep 0.05
hyprctl dispatch sendshortcut , n, class:arcadia-launcher.exe
sleep 0.05


PREV_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
hyprctl dispatch focuswindow class:arcadia-launcher.exe
sleep 0.1
ydotool key 28:1 28:0
sleep 0.3
ydotool key 28:1 28:0
sleep 0.3
ydotool key 28:1 28:0
sleep 0.1
hyprctl dispatch focuswindow "address:$PREV_WINDOW"

