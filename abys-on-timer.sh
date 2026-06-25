#!/bin/bash

# Path to the timestamp file
TIMESTAMP_FILE="/tmp/.last_bragi_timestamp"
TIMESTAMP_A_FILE="/tmp/.last_bers_timestamp"
ALTTAB_DELAY=0.5
SKILL_DELAY=0.3

RERUN=false
#RERUN=true

WINDOW=3
#MODE="DUO"
MODE="BRAGI"

# --- Environment "Stealing" for SSH (Corrected Path) ---
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Define the runtime directory
    USER_ID=$(id -u)
    export XDG_RUNTIME_DIR="/run/user/$USER_ID"

    # Find the signature in the user-specific runtime path
    # We look for the directory that isn't 'hyprctl'
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | grep -v "hyprctl" | head -n 1)
fi

action_switch(){
  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  echo "cur win is $WINDOW"
  local BRAGI_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("Kimichuri")) | .workspace.id'`
  echo "bragi win is $BRAGI_WINDOW"

  if [[ -z "$BRAGI_WINDOW" ]]; then
    echo "Looks like no bragi running. Skipping role"
    return -1
  fi

  local YD_KEY=$((1+($BRAGI_WINDOW)))
  echo "YD_KEY is $YD_KEY"

  if [[ (( "$WINDOW" -ne "$BRAGI_WINDOW" )) ]]; then
    echo "Pick bragi window: $(date)"
    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.2
  fi
}

action_switch

check_another_instances() {
  # Find processes matching the script name, excluding the current process
  previous_pids=$(pgrep -f "main.sh" | grep -v "$$")

  if [[ -n "$previous_pids" ]]; then
    RERUN=true
    WINDOW=3

    echo "Killing previous instances (PIDs: $previous_pids)"
    kill $previous_pids

  fi
}

check_another_instances

action_bragi() {
  
  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "Bragi: $(date)"
  # A for Encore
  ydotool key 30:1 30:0
  sleep 0.5
}


action_assasin_cross() {

  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "Bragi: $(date)"
  # E for Assassin-cross
  ydotool key 18:1 18:0
  sleep 0.5
}

action_bragi_new() {

  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "Bragi: $(date)"
  # W for bragi
  ydotool key 17:1 17:0
  sleep 0.5
}

action_cancel_bragi() {
  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  # swap wep for cancel Z-X
  ydotool key 44:1 44:0
  sleep 0.5
  ydotool key 45:1 45:0
  sleep 0.3
}

action_cancel_bragi

random_double() {
    awk 'BEGIN { srand(); print 1 + rand() }'
}

random_range() {
    # Takes two arguments: $1 = min, $2 = max
    awk -v min="$1" -v max="$2" 'BEGIN { srand(); print min + (max - min) * rand() }'
}

if [[ $MODE == "BRAGI" ]]; then
  while true; do
    action_bragi
    #sleep ((60 + $random_double))
    #sleep ((60 + (random_range 1 2.5))
    sleep 60
    sleep random_range 3 4
  done
fi

if [[ $MODE == "DUO" ]]; then
  while true; do
    action_bragi_new
    sleep 1.5
    action_cancel_bragi
    sleep 8
    action_assasin_cross
    sleep 1.5
    action_cancel_bragi
    sleep 8
  done
fi
