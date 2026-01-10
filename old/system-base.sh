#!/bin/bash

TIMESTAMP_FILE="/tmp/.last_tp_timestamp"

WALK_DELAY=7
WALK_RND_DELAY=3

WARP_DALAY=0
WARP_BASE_DALAY=50
WARP_RND_DELAY=20

# Action Click and move
action_move() {
  echo "Move char: $(date)"

  # ydotool mousemove -x -30 -y 30
  # click to move
  ydotool click 0xC0;
  sleep 1.2; 
  ydotool click 0xC0;
  sleep 0.3; 
}

action_warp() {
  echo "Warp: $(date)"

  echo type z| dotool;
  sleep 0.1; 
}

action_choose_direction() {
  echo '111'
}

if [ ! -f "$TIMESTAMP_FILE" ]; then
  touch "$TIMESTAMP_FILE"
  date +%s > "$TIMESTAMP_FILE"  # Store the current epoch time
fi

while true; do

  last_run=$(cat "$TIMESTAMP_FILE")
  current_time=$(date +%s)
  time_diff=$((current_time - last_run))

  # warp section
  # Check for timeout have passed since the last run
  if (( time_diff > $WARP_DALAY )); then  
    
    action_warp
    # Update the timestamp after Action 2 is executed
    date +%s > "$TIMESTAMP_FILE"
    WARP_DALAY=$(( (RANDOM % WARP_BASE_DALAY) + (WARP_RND_DELAY) ))
  fi

  sleep 3

  # walk section
  action_move

  # Generate a random number 
  random_sleep=$(( ( RANDOM % (WALK_RND_DELAY + 1)) + (WALK_DELAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done
