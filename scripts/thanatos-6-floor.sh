#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/../functions/global.sh"

# --- Environment "Stealing" for SSH (Corrected Path) ---
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Define the runtime directory
    USER_ID=$(id -u)
    export XDG_RUNTIME_DIR="/run/user/$USER_ID"
    
    # Find the signature in the user-specific runtime path
    # We look for the directory that isn't 'hyprctl'
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | grep -v "hyprctl" | head -n 1)
fi

WINDOW=$(hyprctl activeworkspace -j | jq '.id')

npc_talk() {
    ydotool key 28:1 28:0
    sleep 0.3
    ydotool key 28:1 28:0
    sleep 0.3
    ydotool key 28:1 28:0
    sleep 0.3
}

win 3
if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
fi
npc_talk

#win 4
ydotool key 125:1 5:1 125:0 5:0
sleep 0.5
npc_talk

#win 5
ydotool key 125:1 6:1 125:0 6:0
sleep 0.5
npc_talk