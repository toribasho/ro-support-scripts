#!/bin/bash

send_key_state() {
  hyprctl dispatch sendkeystate , $1, down, class:arcadia-launcher.exe
  sleep 0.01
  hyprctl dispatch sendkeystate , $1, up, class:arcadia-launcher.exe
}

send_key() {
  hyprctl dispatch sendshortcut , $1, class:arcadia-launcher.exe
}

send_key_state enter
sleep 0.3
send_key_state s
sleep 2.4
send_key_state s
sleep 0.05
send_key_state a
sleep 0.05
send_key_state n
sleep 0.5

send_key_state enter
sleep 0.3
send_key_state enter
sleep 0.3
send_key_state enter
sleep 0.3


#hyprctl dispatch sendshortcut , enter, class:arcadia-launcher.exe
#sleep 0.3
#hyprctl dispatch sendshortcut , s, class:arcadia-launcher.exe
#sleep 2.4
#hyprctl dispatch sendshortcut , s, class:arcadia-launcher.exe
#sleep 0.05
#hyprctl dispatch sendshortcut , a, class:arcadia-launcher.exe
#sleep 0.05
#hyprctl dispatch sendshortcut , n, class:arcadia-launcher.exe
#sleep 0.05


#PREV_WINDOW=$(hyprctl activewindow -j | jq -r ".address
#hyprctl dispatch focuswindow class:arcadia-launcher.exe
#sleep 0.05
#hyprctl dispatch sendshortcut , enter, class:arcadia-launcher.exe
#ydotool key 28:1 28:0
#sleep 0.05
#hyprctl dispatch focuswindow "address:$PREV_WINDOW"

