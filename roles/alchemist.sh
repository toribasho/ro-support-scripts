#!/bin/bash

# Call action_alch
# Specify:
# 1 - slot for throw bers


action_throw_bers() {
  echo "Throw bers from Alch: $(date)"

  # press x for Bererk Pot Pitcher
  ydotool key 45:1 45:0
  sleep 0.5

  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $((236+12*($slot-1)))
  sleep 0.5

  # click on sage
  ydotool click 0xC0;
  sleep 0.5
}

action_alch() {
  local slot=${1:-1}
  local TIMESTAMP_A_FILE="/tmp/.last_bers_timestamp"

  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  local ALCH_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "aocli.exe") | select(.title | test("Alcaster")) | .workspace.id'`
  local YD_KEY=$((1+($ALCH_WINDOW)))

  if [[ -z "$ALCH_WINDOW" ]]; then
    echo "Looks like no alchemist running. Skipping role"
    return -1
  fi

  if [[ (( "$WINDOW" -ne $ALCH_WINDOW )) ]]; then
    echo "alt + tab to Alch: $(date)"
    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.3
  fi
  
  local last_run_a=$(cat "$TIMESTAMP_A_FILE")
  local current_time_a=$(date +%s)
  local time_diff_a=$((current_time_a - last_run_a))

  if [ ! -f "$TIMESTAMP_A_FILE" ]; then
    touch "$TIMESTAMP_A_FILE"
    date +%s > "$TIMESTAMP_A_FILE"  # Store the current epoch time
    action_throw_bers
  fi

  if (( time_diff_a > 750 )); then  # 750 seconds = 12.5 minutes
    action_throw_bers
    # Update the timestamp after Action 2 is executed
    date +%s > "$TIMESTAMP_A_FILE"
  else
    echo "Skipping Action Alch LINK + BERS. Only $(($time_diff_a / 60)) minutes and $((time_diff_a % 60)) seconds have passed."
  fi
}
