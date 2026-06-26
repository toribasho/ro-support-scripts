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

kim-on() {
  if [[ (( "$WINDOW" -ne 5)) ]]; then
    echo "alt + tab to alch: $(date)"
    ydotool key 125:1 6:1 125:0 6:0
    sleep 0.5
    WINDOW=5
  fi
  # A - encore 
  ydotool key 30:1 30:0
  sleep 0.5
  ydotool key 125:1 5:1 125:0 5:0
  WINDOW=4

}

kim-on
