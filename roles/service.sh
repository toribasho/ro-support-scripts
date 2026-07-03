#!/bin/bash

# Call  
# Specify:
# [1] - force to call it again
# [2] - [service]/heart = choose songs ! TODO

action_service() {
  echo "service: $(date)"
  
  # A for Encore
  ydotool key 30:1 30:0
  sleep 0.5
}

action_service_new() {
  echo "service: $(date)"

  # W for service
  ydotool key 17:1 17:0
  sleep 0.5
}

action_cancel_service() {
  # swap wep for cancel
  ydotool key 44:1 44:0
  sleep 0.3
  ydotool key 45:1 45:0
  sleep 0.3
}

action_dancer() {
  local force=${1:-false}
  local mode=${2:-"service"}
  local TIMESTAMP_FILE="/tmp/.last_service_timestamp"

  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  echo "cur win is $WINDOW"
  local SERVICE_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("Dance-till-Midnight")) | .workspace.id'`
  echo "service win is $SERVICE_WINDOW"

  if [[ -z "$SERVICE_WINDOW" ]]; then
    echo "Looks like no service running. Skipping role"
    return -1
  fi
  
  local YD_KEY=$((1+($SERVICE_WINDOW)))
  echo "YD_KEY is $YD_KEY"

  if [[ (( "$WINDOW" -ne "$SERVICE_WINDOW" )) ]]; then
    echo "Pick service window: $(date)"
    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.2
  fi

  if [ ! -f "$TIMESTAMP_FILE" ]; then
    touch "$TIMESTAMP_FILE"
    date +%s > "$TIMESTAMP_FILE" 
    action_service_new
  fi

  local last_run=$(cat "$TIMESTAMP_FILE")
  local current_time=$(date +%s)
  local time_diff=$((current_time - last_run))

  if (( time_diff > 600 )); then  # 600 seconds = 10 minutes
    action_service_new
    # Update the timestamp after Action 2 is executed
    date +%s > "$TIMESTAMP_FILE"
  elif (( time_diff > 170 && time_diff < 180 )) || [[ $force == true ]]; then  # 160 seconds =  3 minutes
    action_cancel_service
    action_service
    date +%s > "$TIMESTAMP_FILE"
  elif (( time_diff > 180 )); then  # 180 seconds = < 3 minutes
    action_service
    date +%s > "$TIMESTAMP_FILE"
  else
    echo "Skipping Action. Only $(($time_diff / 60)) minutes and $((time_diff % 60)) seconds have passed."
  fi
}
