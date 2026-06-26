#!/bin/bash

TIMESTAMP_FILE="/tmp/.last_move_timestamp"
TIMESTAMP_DIFF=0

WALK_DELAY=250

WALK_RND_DELAY=20
WALK_FIX_DELAY=30

SLEEP_DALAY=50
SLEEP_RND_DELAY=10

# Action 2: This action executes only if the time since the last run is greater than 5 minutes.
action_move() {
  echo "Move char: $(date)"

  # ydotool mousemove -x -30 -y 30
  # click to move
  ydotool click 0xC0;
  sleep 0.3; 
  TIMESTAMP_DIFF=$(( (RANDOM % WALK_RND_DELAY + 1) + (WALK_FIX_DELAY) ))
}

if [ ! -f "$TIMESTAMP_FILE" ]; then
  touch "$TIMESTAMP_FILE"
  date +%s > "$TIMESTAMP_FILE"  # Store the current epoch time
fi

while true; do

  last_run=$(cat "$TIMESTAMP_FILE")
  current_time=$(date +%s)
  time_diff=$((current_time - last_run))

  # Check if 5 minutes have passed since the last run
  if (( time_diff > $WALK_DELAY + $TIMESTAMP_DIFF )); then  
    action_move
    # Update the timestamp after Action 2 is executed
    date +%s > "$TIMESTAMP_FILE"
  else
    echo "Skipping Action 2. Only $(($time_diff / 60)) minutes and $((time_diff % 60)) seconds have passed."
  fi

  echo type z| dotool
  # Generate a random number 
  random_sleep=$(( ( RANDOM % (SLEEP_RND_DELAY + 1)) + (SLEEP_DALAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done
