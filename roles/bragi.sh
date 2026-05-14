#!/bin/bash

# Call action_bard
# Specify:
# [1] - [bragi]/ass = choose songs


action_bragi() {
  echo "Bragi: $(date)"
  
  # A for Encore
  ydotool key 30:1 30:0
  sleep 0.5
}

action_bragi_new() {
  echo "Bragi: $(date)"

  # W for bragi
  ydotool key 17:1 17:0
  sleep 0.5
}

action_cancel_bragi() {
  # swap wep for cancel
  ydotool key 44:1 44:0
  sleep 0.3
  ydotool key 45:1 45:0
  sleep 0.3
}

action_bard() {
  local mode=${1:-"bragi"}
  local TIMESTAMP_FILE="/tmp/.last_bragi_timestamp"

  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  echo "cur win is $WINDOW"
  local BRAGI_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("Clampsi")) | .workspace.id'`
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
    sleep 0.5
  fi

  if [ ! -f "$TIMESTAMP_FILE" ]; then
    touch "$TIMESTAMP_FILE"
    date +%s > "$TIMESTAMP_FILE" 
    action_bragi_new
  fi

  local last_run=$(cat "$TIMESTAMP_FILE")
  local current_time=$(date +%s)
  local time_diff=$((current_time - last_run))

  if (( time_diff > 6000 )); then  # 6000 seconds = 100 minutes
    action_bragi_new
    # Update the timestamp after Action 2 is executed
    date +%s > "$TIMESTAMP_FILE"
  elif (( time_diff > 170 )); then  # 170 seconds = < 3 minutes
    action_cancel_bragi
    action_bragi
    date +%s > "$TIMESTAMP_FILE"
  else
    echo "Skipping Action. Only $(($time_diff / 60)) minutes and $((time_diff % 60)) seconds have passed."
  fi
}
