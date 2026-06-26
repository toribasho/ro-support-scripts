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

source ~/Games/main.vars
last_move_time=0

#FEED_TIMESTAMP_FILE="/tmp/.feed_timestamp"
#FEED_DALAY=600
#
#SLEEP_DALAY=3
#SLEEP_RND_DELAY=2

action_select_one() {
  echo "Select 1st char: $(date)"
  # self
  ydotool mousemove --absolute -x 275 -y 170
  sleep 0.1
  ydotool click 0xC0
  sleep 1
}

## TODO:
# Set self location of char and calc offset from that position. Or try to make windows on same position
action_do_move() {
  echo "Move char: $(date)"

  MOVE_TO_X=230
  MOVE_TO_Y=170

  # X>270 && X<282
  # Y>168 && Y<179

  if [[ "$MOVE_RND_DISTANCE" == "true" ]]; then

    if [[ "$MOVE_RND_FAR" == "true" ]]; then 
      move_dist_x=$(( ( RANDOM % (MOVE_FAR_DISTANCE_X + 1)) ))
      move_dist_Y=$(( ( RANDOM % (MOVE_FAR_DISTANCE_Y + 1)) ))

      MOVE_TO_X=$(( MOVE_TO_X + move_dist_x ))
      MOVE_TO_Y=$(( MOVE_TO_Y + move_dist_y ))
    else
      move_dist_x=$(( ( RANDOM % (MOVE_NEAR_DISTANCE_X + 1)) ))
      move_dist_Y=$(( ( RANDOM % (MOVE_NEAR_DISTANCE_Y + 1)) ))

      MOVE_TO_X=$(( MOVE_TO_X + move_dist_x ))
      MOVE_TO_Y=$(( MOVE_TO_Y + move_dist_y ))      
    fi    

  fi

  if (( MOVE_TO_X>265 && MOVE_TO_X<287 && MOVE_TO_Y>163 && MOVE_TO_Y<184 )); then
    echo "Chose self spot. fixig..."
    MOVE_TO_X=290
    MOVE_TO_Y=185
  fi

  ydotool mousemove --absolute -x $MOVE_TO_X -y $MOVE_TO_Y
  sleep 0.5
  ydotool click 0xC0;
  sleep 0.3; 
}

action_move() {
  if [[ "$SMART_MOVE_DELAY" == "true" ]]; then
    cur_time=$(date +%s)
    time_diff_move=$((cur_time - last_move_time))

    # Check if 1st timeout reached target
    if (( time_diff_move + SLEEP_RND_DELAY + SLEEP_DALAY > MOVE_MAX_DELAY )); then 
      action_do_move
      last_move_time=$(date +%s)
    fi
  else
    action_do_move
  fi
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

  if [[ "$FEED_ON_CENTER" == "true" ]]; then
    # move to feed btn at default win location at tiny-arch
    ydotool mousemove --absolute -x 270 -y 185
    sleep 0.8
    ydotool click 0xC0
    sleep 0.3
    ydotool click 0xC0
    sleep 0.3
  else
    # default setup with win on center
    ydotool mousemove --absolute -x 230 -y 155
    sleep 0.8
    ydotool click 0xC0
    sleep 0.8
    ydotool mousemove --absolute -x 320 -y 200
    sleep 0.8
    ydotool click 0xC0
    sleep 1    
  fi

  ydotool key 13:1 13:0
  #echo type =| dotool
  sleep 1
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

  # action_move
  # #action_select_one
  # action_warp
  # #action_wing
  # #action_move

  if [[ "$SET_FOCUS_FIRST" == "true" ]]; then 
    action_select_one
  fi 

  if [[ "$MOVE_BEFORE_WARP" == "true" ]]; then 
    action_move
  fi

  if [[ "$USE_WARP" == "true" ]]; then 
    action_warp
  elif [[ "$USE_WING" == "true" ]]; then 
    action_wing
  fi

  if [[ "$MOVE_AFTER_WARP" == "true" ]]; then 
    action_move
  fi    

  # Generate a random number 
  random_sleep=$(( ( RANDOM % (SLEEP_RND_DELAY + 1)) + (SLEEP_DALAY) )) 

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done

