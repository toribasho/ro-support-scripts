#!/bin/bash

# Path to the timestamp file
TIMESTAMP_FILE="/tmp/.last_bragi_timestamp"
TIMESTAMP_A_FILE="/tmp/.last_bers_timestamp"
ALTTAB_DELAY=0.5
SKILL_DELAY=0.3

RERUN=false
#RERUN=true

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


WINDOW=`hyprctl activeworkspace -j | jq '.id'`
# MODE="BS"
#MODE="DUO"
#MODE="BRAGI"
MODE="FULL-BRAGI"

check_another_instances() {
  # Find processes matching the script name, excluding the current process
  previous_pids=$(pgrep -f "bragi-on-timer.sh" | grep -v "$$")

  if [[ -n "$previous_pids" ]]; then
    RERUN=true

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

action_service() {
  
  if [[ (( "$WINDOW" -ne 5 )) ]]; then
    echo "alt tab back to BS: $(date)"
    ydotool key 125:1 6:1 125:0 6:0
    sleep 0.5
    WINDOW=5
  fi

  echo "Service: $(date)"
  # A for Encore
  ydotool key 30:1 30:0
  sleep 0.5
}

action_cancel_service() {

  if [[ (( "$WINDOW" -ne 5 )) ]]; then
    echo "alt tab back to BS: $(date)"
    ydotool key 125:1 6:1 125:0 6:0
    sleep 0.5
    WINDOW=5
  fi

  # swap wep for cancel Z-X
  ydotool key 44:1 44:0
  sleep 0.5
  ydotool key 45:1 45:0
  sleep 0.3
}


action_assasin_cross() {

  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "Ass cross: $(date)"
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

  echo "Bragi fresh: $(date)"
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

if [[ $MODE == "BRAGI" ]]; then
  while true; do
    action_bragi
    sleep 1.5
    action_cancel_bragi
    sleep 17
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

if [[ $MODE == "BS" ]]; then
  while true; do
    action_cancel_bragi
    sleep 0.1
    action_bragi
    sleep 0.1
    action_cancel_service
    sleep 0.1
    action_service
    song_duration=$(($(date +%s) + 165 ))
    storeVar "songs-sleep-timer" $song_duration
    sleep 180
  done
fi


if [[ $MODE == "FULL-BRAGI" ]]; then
  while true; do
    action_cancel_bragi
    sleep 0.1
    action_bragi
    song_duration=$(($(date +%s) + 165 ))
    storeVar "songs-sleep-timer" $song_duration
    sleep 180
  done
fi