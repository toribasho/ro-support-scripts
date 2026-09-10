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

check_another_instances() {
  # Find processes matching the script name, excluding the current process
  previous_pids=$(pgrep -f "fortune-mayor.sh" | grep -v "$$")

  if [[ -n "$previous_pids" ]]; then
    RERUN=true

    echo "Killing previous instances (PIDs: $previous_pids)"
    kill $previous_pids

  fi
}

RUN_ARG=${1:-"ALL"}

check_another_instances

action_cancel_service() {

  if [[ (( "$WINDOW" -ne 5 )) ]]; then
    echo "alt tab back to DNC: $(date)"
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

action_cancel_bragi() {
  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BRD: $(date)"
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

action_dancer_fortune() {

  if [[ (( "$WINDOW" -ne 5 )) ]]; then
    echo "alt tab back to DNC: $(date)"
    ydotool key 125:1 6:1 125:0 6:0
    sleep 0.5
    WINDOW=5
  fi

  echo "Fortune's kiss: $(date)"
  # E for Fortune's kiss
  ydotool key 18:1 18:0
  sleep 0.5
}

action_service_new() {
  echo "service: $(date)"

  # W for service
  ydotool key 17:1 17:0
  sleep 0.5
}

action_dancer_battle_drums() {

  if [[ (( "$WINDOW" -ne 5 )) ]]; then
    echo "alt tab back to DNC: $(date)"
    ydotool key 125:1 6:1 125:0 6:0
    sleep 0.5
    WINDOW=5
  fi

  echo "Battledrum: $(date)"
  # F for B drums
  ydotool key 33:1 33:0
  sleep 0.5
}

if [[ $RUN_ARG == "ALL" ]]; then
  action_cancel_bragi
  sleep 0.1
  action_cancel_service
  sleep 0.1
  action_dancer_fortune
  sleep 0.5
  action_dancer_battle_drums
else
  action_cancel_service
  sleep 0.1
  action_dancer_fortune
  sleep 0.5
  action_cancel_service
  sleep 0.1
  action_service_new
fi