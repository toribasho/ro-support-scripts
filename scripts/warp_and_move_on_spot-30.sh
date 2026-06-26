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

SLEEP_DALAY=23
SLEEP_RND_DELAY=2

LEFT=1

action_select_one() {
  echo "Select 1st char: $(date)"
  ydotool mousemove --absolute -x 230 -y 180
  sleep 0.1
  ydotool click 0xC0
  sleep 1
}

action_move() {
  echo "Move char: $(date)"

  # ydotool mousemove --absolute -x 120 -y 190
  ydotool mousemove --absolute -x 200 -y 170
  sleep 0.5
  ydotool click 0xC0;
  sleep 1; 
}

action_warp() {
  #echo type .| dotool
  ydotool key 52:1 52:0
  sleep 1
  #echo key enter| dotool
  ydotool key 28:1 28:0
  sleep 1
}

action_wing() {
  echo type z| dotool
  sleep 0.5
}

action_feed() {
  # set focus to window
  # action_select_one
  # call homunculus window
  #echo type =| dotool
  ydotool key 13:1 13:0
  sleep 1
  # move to feed btn
  ydotool mousemove --absolute -x 230 -y 155
#  ydotool mousemove --absolute -x 280 -y 215
  #ydotool mousemove --absolute -x 320 -y 200
  sleep 0.8
  ydotool click 0xC0
  sleep 0.8
  ydotool mousemove --absolute -x 320 -y 200
  sleep 0.8  
  ydotool click 0xC0
  sleep 1
  ydotool key 13:1 13:0
  #echo type =| dotool
  sleep 1
}

action_move_on_spot(){
  #ydotool mousemove --absolute -x 220 -y 190
  if (( LEFT == 1 )); then
    ydotool mousemove --absolute -x 260 -y 170
    LEFT=0
  else
    ydotool mousemove --absolute -x 290 -y 170
    LEFT=1
  fi
  
  sleep 0.3
  ydotool click 0xC0
  sleep 1
  #ydotool mousemove --absolute -x 250 -y 190
  #ydotool mousemove --absolute -x 290 -y 170
  #sleep 0.3
  #ydotool click 0xC0
}

sleep 1

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

  #action_move
  #action_select_one
  #action_warp
  #action_wing
  #action_move
  action_move_on_spot

  # Generate a random number 
  random_sleep=$(( ( RANDOM % (SLEEP_RND_DELAY + 1)) + (SLEEP_DALAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done

