#!/bin/bash

# Get the script's name (without the path)
SCRIPT_NAME=$(basename "$0")

# Function to kill previous instances
kill_previous_instances() {
  # Find processes matching the script name, excluding the current process
  local previous_pids=$(pgrep -f "$SCRIPT_NAME" | grep -v "$$")

  if [[ -n "$previous_pids" ]]; then
    echo "Killing previous instances (PIDs: $previous_pids)"
    kill $previous_pids
  fi
}

# Kill previous instances before starting the loop
kill_previous_instances

# Trap SIGINT (Ctrl+C) and exit gracefully
trap "echo 'Exiting...'; exit 0" INT

action_move_one() {
  echo "Move 1st char: $(date)"

  # move to 7 o'clock far
  ydotool mousemove --absolute -x 120 -y 195
  sleep 0.1; 
  # click to move. may by twice?
  ydotool click 0xC0;
  sleep 0.1; 
  # ydotool click 0xC0;
  # sleep 0.1;   
}

action_move_two() {
  echo "Move 2nd char: $(date)"

  # move to 9 o'clock close
  ydotool mousemove --absolute -x 590 -y 195
  sleep 0.1; 
  # click to move. may by twice?
  ydotool click 0xC0
  sleep 0.1; 
  # ydotool click 0xC0;
  # sleep 0.1;   
}

action_select_one() {
  echo "Select 1st char: $(date)"
  ydotool mousemove --absolute -x 240 -y 195
  sleep 0.1
  ydotool click 0xC0
  sleep 0.1
}

action_select_two() {
  echo "Select 2nd char: $(date)"
  ydotool mousemove --absolute -x 725 -y 195
  sleep 0.1 
  ydotool click 0xC0
  sleep 0.1
}

action_warp() {
  echo type .| dotool
  sleep 0.1
  echo key enter| dotool
  sleep 0.3
}

action_wing() {
  echo type z| dotool
  sleep 0.3
}

ONE_TIMESTAMP_FILE="/tmp/.one_move_timestamp"
ONE_SLEEP_DALAY=6
ONE_SLEEP_RND_DELAY=4

# Get the last run timestamp. If it doesn't exist, create it and set it to the current time.
if [ ! -f "$ONE_TIMESTAMP_FILE" ]; then
  touch "$ONE_TIMESTAMP_FILE"
  date +%s > "$ONE_TIMESTAMP_FILE"  # Store the current epoch time
  action_select_one
  action_warp
  action_move_one
fi

TWO_TIMESTAMP_FILE="/tmp/.two_move_timestamp"
TWO_SLEEP_DALAY=10
TWO_SLEEP_RND_DELAY=4

# Get the last run timestamp. If it doesn't exist, create it and set it to the current time.
if [ ! -f "$TWO_TIMESTAMP_FILE" ]; then
  touch "$TWO_TIMESTAMP_FILE"
  date +%s > "$TWO_TIMESTAMP_FILE"  # Store the current epoch time
  action_select_two
  action_wing
  action_move_two
fi

random_sleep_one=0
random_sleep_two=0

while true; do

  last_run_one=$(cat "$ONE_TIMESTAMP_FILE")
  current_time=$(date +%s)
  time_diff_one=$((current_time - last_run_one))

  # Check if 1st timeout reached target
  if (( time_diff_one > random_sleep_one )); then 
    action_select_one
    action_warp
    action_move_one

    random_sleep_one=$(( ( RANDOM % (ONE_SLEEP_RND_DELAY + 1)) + (ONE_SLEEP_DALAY) )) 

    # Update the timestamp
    date +%s > "$ONE_TIMESTAMP_FILE"
  # else
  #   echo "Skipping Move 1. Only $(($time_diff_one / 60)) minutes and $((time_diff_one % 60)) seconds have passed."
  fi

  last_run_two=$(cat "$TWO_TIMESTAMP_FILE")
  current_time=$(date +%s)
  time_diff_two=$((current_time - last_run_two))

  # Check if 2nd timeout reached target
  if (( time_diff_two > random_sleep_two )); then 
    action_select_two
    action_wing
    action_move_two

    random_sleep_two=$(( ( RANDOM % (TWO_SLEEP_RND_DELAY + 1)) + (TWO_SLEEP_DALAY) )) 

    # Update the timestamp
    date +%s > "$TWO_TIMESTAMP_FILE"
  # else
  #   echo "Skipping Move 2. Only $(($time_diff_two / 60)) minutes and $((time_diff_two % 60)) seconds have passed."
  fi


  sleep 1
done
