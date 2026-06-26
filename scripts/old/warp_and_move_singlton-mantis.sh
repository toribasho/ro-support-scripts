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

SLEEP_DALAY=16
SLEEP_RND_DELAY=6

action_move() {
  echo "Move char: $(date)"

  # ydotool mousemove -x -30 -y 30
  # click to move
  ydotool click 0xC0;
  sleep 0.1; 
}

action_warp() {
  echo type .| dotool
  sleep 0.1
  echo key enter| dotool
}

action_wing() {
  echo type z| dotool
}

while true; do

  action_warp
  sleep 0.1

  action_move

  # Generate a random number 
  random_sleep=$(( ( RANDOM % (SLEEP_RND_DELAY + 1)) + (SLEEP_DALAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done
