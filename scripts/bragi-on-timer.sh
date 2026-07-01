#!/bin/bash

# Path to the timestamp file
TIMESTAMP_FILE="/tmp/.last_bragi_timestamp"
TIMESTAMP_A_FILE="/tmp/.last_bers_timestamp"
ALTTAB_DELAY=0.5
SKILL_DELAY=0.3

RERUN=false
#RERUN=true

WINDOW=3
MODE="DUO"
#MODE="BRAGI"

check_another_instances() {
  # Find processes matching the script name, excluding the current process
  previous_pids=$(pgrep -f "bragi-on-timer.sh" | grep -v "$$")

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

action_service() {
  
  if [[ (( "$WINDOW" -ne 4 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 5:1 125:0 5:0
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
    action_bragi
    sleep 0.5
    action_service
    sleep 178
  done
fi
