#!/bin/bash

# Path to the timestamp file
TIMESTAMP_FILE="/tmp/.last_link_timestamp"
ALTTAB_DELAY=0.5
SKILL_DELAY=0.3

RERUN=false

WINDOW=4

check_another_instances() {
  # Find processes matching the script name, excluding the current process
  previous_pids=$(pgrep -f "warp_and_move" | grep -v "$$")

  if [[ -n "$previous_pids" ]]; then
    RERUN=true
    WINDOW=4

    echo "Killing previous instances (PIDs: $previous_pids)"
    kill $previous_pids

  fi
}

# echo key Super+1 | dotool
# sleep 0.1

check_another_instances

# Action 1: This action executes every time.
action_bs_buff() {
  
  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "BS buffs: $(date)"

  #echo type z| dotool
  ydotool key 44:1 44:0
  sleep 0.6
  # echo type x| dotool
  # sleep 0.3
  #echo type c| dotool
  ydotool key 46:1 46:0
  sleep 0.6

  # # Press Z
  # ydotool key 44:1 key 44:0;
  # sleep 0.7; 
  # # Press X
  # ydotool key 45:1 key 45:0;
  # sleep 0.7; 
  # # Press C
  # ydotool key 46:1 key 46:0;
}

# Action 2: This action executes only if the time since the last run is greater than 5 minutes.
action_link_bs() {
  echo "Link BS: $(date)"

  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt + tab to linker: $(date)"
    #echo key Super+2 | dotool
    ydotool key 125:1 3:1 125:0 3:0
    sleep 1
    WINDOW=2
  fi

  # press Q for BS link
  #echo type q| dotool
  ydotool key 16:1 16:0
  sleep 0.5

  # move to 2nd slot
  ydotool mousemove --absolute -x 190 -y 140
  sleep 0.5

  # click on BS
  ydotool click 0xC0;
  sleep 1.5
}

action_link_rogue() {
  echo "Link ROGUE: $(date)"

  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt + tab to linker: $(date)"
    #echo key Super+2 | dotool
    ydotool key 125:1 3:1 125:0 3:0
    sleep 1
    WINDOW=2
  fi

  # press w for Rogue link
  #echo type w| dotool
  ydotool key 17:1 17:0
  sleep 0.5

  # move to 1st slot
  ydotool mousemove --absolute -x 190 -y 130
  # move to 5th slot
  # ydotool mousemove --absolute -x 190 -y 180
  sleep 0.7

  # click on Rogue
  ydotool click 0xC0;
  sleep 0.7

  echo "alt tab back to BS: $(date)"
  #echo key Super+3 | dotool
  ydotool key 125:1 4:1 125:0 4:0
  sleep 1
  WINDOW=3  
}



# Get the last run timestamp. If it doesn't exist, create it and set it to the current time.
if [ ! -f "$TIMESTAMP_FILE" ]; then
  touch "$TIMESTAMP_FILE"
  date +%s > "$TIMESTAMP_FILE"  # Store the current epoch time
  # action_link_bs
fi

last_run=$(cat "$TIMESTAMP_FILE")
current_time=$(date +%s)
time_diff=$((current_time - last_run))

# Check if 5 minutes have passed since the last run

if (( time_diff > 300 )); then  # 300 seconds = 5 minutes
  action_link_bs
  # Update the timestamp after Action 2 is executed
  date +%s > "$TIMESTAMP_FILE"
else
  echo "Skipping Action 2. Only $(($time_diff / 60)) minutes and $((time_diff % 60)) seconds have passed."
fi

# Execute Action 1 always
action_link_rogue
action_bs_buff

if [[ "$RERUN" == "false" ]]; then
  #echo key Super+4 | dotool
  ydotool key 125:1 5:1 125:0 5:0
fi

if [[ "$RERUN" == "true" ]]; then 
  #echo key Super+4 | dotool
  ydotool key 125:1 5:1 125:0 5:0
  WINDOW=3
  sleep 0.5
  ydotool mousemove --absolute -x 120 -y 180
  sleep 0.3
  ydotool click 0xC0;
  sleep 0.3
  bash -c /home/tori/Games/warp_and_move.sh &
fi
