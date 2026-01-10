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

FEED_TIMESTAMP_FILE="/tmp/.feed_timestamp"
FEED_DALAY=600

SLEEP_DALAY=12
SLEEP_RND_DELAY=6

action_select_one() {
  echo "Select 1st char: $(date)"
  ydotool mousemove --absolute -x 230 -y 160
  sleep 0.1
  ydotool click 0xC0
  sleep 0.1
}

action_move() {
  echo "Move char: $(date)"

  ydotool mousemove --absolute -x 120 -y 160
  sleep 0.1
  ydotool click 0xC0;
  sleep 0.1; 
}

action_warp() {
  echo type .| dotool
  sleep 0.1
  echo key enter| dotool
  sleep 0.3
}

action_wing() {
  echo type z| dotool
}

action_feed() {
  # set focus to window
  action_select_one
  # call homunculus window
  echo key =| dotool
  sleep 0.1
  ydotool mousemove --absolute -x 270 -y 185
  sleep 0.1
  ydotool click 0xC0
  sleep 0.1
  ydotool click 0xC0
  sleep 0.1
  echo key =| dotool
  sleep 0.1
}

if [ ! -f "$FEED_TIMESTAMP_FILE" ]; then
  touch "$FEED_TIMESTAMP_FILE"
  date +%s > "$FEED_TIMESTAMP_FILE"  # Store the current epoch time
  action_feed
fi

while true; do

  last_run_feed=$(cat "$FEED_TIMESTAMP_FILE")
  current_time=$(date +%s)
  time_diff_feed=$((current_time - last_run_feed))

  # Check if 1st timeout reached target
  if (( time_diff_feed > FEED_DALAY )); then 
    echo "Time to feed..."
    action_feed
    date +%s > "$FEED_TIMESTAMP_FILE"
  fi

  action_select_one
  action_wing
  action_move

  # Generate a random number 
  random_sleep=$(( ( RANDOM % (SLEEP_RND_DELAY + 1)) + (SLEEP_DALAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done

