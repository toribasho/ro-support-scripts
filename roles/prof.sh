#!/bin/bash

# Specify:
# 1 - SLOT for SP exchange
# [2] - true/faslse to cast indulge
# [3] - Num of indulge cast
action_prof() {
  local slot=${1:-1}
  local cast_indulge=${2:-false}
  local num_cast_indulge=${3:-1}

  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  local PROF_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("Naoo")) | .workspace.id'`


  if [[ -z "$PROF_WINDOW" ]]; then
    echo "Looks like no prof running. Skipping role"
    return -1
  fi  

  local YD_KEY=$((1+($PROF_WINDOW)))

  if [[ (( "$WINDOW" -ne "$PROF_WINDOW" )) ]]; then
    echo "alt tab back to Prof: $(date)"
  
    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.2
  fi

  echo "Prof: $(date)"
  
  # Z for Soul exchange
  ydotool key 44:1 44:0

  # adjust slot in a scroll list ( up to 10 right now )
  slot=$(get_real_slot($slot))

  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $((224+12*($slot-1)))
  sleep 0.2

  # click 
  ydotool click 0xC0;
  sleep 0.5

  if [[ "$cast_indulge" == "true" ]]; then
    for ((cast=0; cast<=num_cast_indulge; cast++));
    do 
      # X for Indulge
      ydotool key 45:1 45:0
      sleep 1 # was 0.6
    done
  fi
}
