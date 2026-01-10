#!/bin/bash

SLEEP_DALAY=12
SLEEP_RND_DELAY=6

# Action 2: This action executes only if the time since the last run is greater than 5 minutes.
action_move() {
  echo "Move char: $(date)"

  # ydotool mousemove -x -30 -y 30
  # click to move
  ydotool click 0xC0;
  sleep 0.1; 
}

while true; do

  echo type z| dotool
  sleep 0.1

  action_move

  # Generate a random number 
  random_sleep=$(( ( RANDOM % (SLEEP_RND_DELAY + 1)) + (SLEEP_DALAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done
