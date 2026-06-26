#!/bin/bash

# Path to the timestamp file
TIMESTAMP_FILE="/tmp/.last_link_timestamp"
TIMESTAMP_A_FILE="/tmp/.last_bers_timestamp"
ALTTAB_DELAY=0.5
SKILL_DELAY=0.3

#RERUN=false
RERUN=true

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


check_another_instances

action_throw_blue() {
  echo "Potion Pither on 3rd slot: $(date)"

  if [[ (( "$WINDOW" -ne 4 )) ]]; then
    echo "alt + tab to alch: $(date)"
    ydotool key 125:1 5:1 125:0 5:0
    sleep 0.5
    WINDOW=4
  fi

  # press R for PotionPitcher
  ydotool key 19:1 19:0
  sleep 0.3

  # move to 3nd slot
  # win at right bottom
  #ydotool mousemove --absolute -x 423 -y 258 
  # 2nd slot
  ydotool mousemove --absolute -x 423 -y 247
  sleep 0.3

  # click on BS
  ydotool click 0xC0;
  sleep 0.3
}

throw_count=$1
if [[ ! -n "$throw_count" ]]; then
  throw_count=1
fi

for (( i = 1; i <= $throw_count; i++ )); do
  action_throw_blue
done


if [[ "$RERUN" == "true" ]]; then 
  #bash -c /home/tori/Games/warp_and_move-smort.sh &
  #bash -c /home/tori/Games/warp_and_move.sh &
  bash -c /home/tori/Games/warp_and_move_on_spot.sh &
fi
