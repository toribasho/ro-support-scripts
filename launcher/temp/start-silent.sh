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

CUR_WS=$(hyprctl activeworkspace -j | jq -r '.id')
ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class=="arcadia-launcher.exe") | .address' | head -n 1)
ORIG_WS=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$ADDR\") | .workspace.id")

hyprctl dispatch movetoworkspace "$CUR_WS,address:$ADDR"

PREV_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
#hyprctl dispatch focuswindow class:arcadia-launcher.exe
sleep 0.1
ydotool key 28:1 28:0
sleep 0.3
ydotool key 28:1 28:0
sleep 0.3
ydotool key 28:1 28:0
sleep 0.1

hyprctl dispatch movetoworkspacesilent "$ORIG_WS,address:$ADDR"

#hyprctl dispatch focuswindow "address:$PREV_WINDOW"

