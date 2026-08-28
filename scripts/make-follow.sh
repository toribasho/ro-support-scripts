#!/bin/bash

# --- Environment "Stealing" for SSH (Corrected Path) ---
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Define the runtime directory
    USER_ID=$(id -u)
    export XDG_RUNTIME_DIR="/run/user/$USER_ID"
    
    # Find the signature in the user-specific runtime path
    # We look for the directory that isn't 'hyprctl'
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | grep -v "hyprctl" | head -n 1)

    # For grim ( get pixel color ) i need to export WAYLAND_DISPALY
    export WAYLAND_DISPLAY="wayland-1"
fi

WINDOW=`hyprctl activeworkspace -j | jq '.id'`
PROF_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("Naoo")) | .workspace.id'`


if [[ -z "$PROF_WINDOW" ]]; then
    echo "Looks like no prof running. Skipping role"
    return -1
fi  

YD_KEY=$((1+($PROF_WINDOW)))

if [[ (( "$WINDOW" -ne "$PROF_WINDOW" )) ]]; then
    echo "alt tab back to Prof: $(date)"

    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.2
fi

ydotool mousemove --absolute -x 255 -y 160
ydotool key 54:1
sleep 0.1
echo "right_click" > /tmp/vmouse_cmd
sleep 0.3
ydotool key 54:0