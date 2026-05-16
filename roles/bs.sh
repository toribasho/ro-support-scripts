#!/bin/bash
# Call action_bs
# Specify:
# 1 - [true]/false = Full Adr Rush
# [2] - true/[false] = Adr Rush
# [3] - true/[false] = Over-Thrust
# [4] - true/[false] = Weapon-Perfection

action_bs_buff() {

  echo "BS buffs: $(date)"

  if [[ "$cast_far" == "true" ]]; then 
  # # Press Z
    ydotool key 44:1 44:0
    sleep 0.5
  fi
  if [[ "$cast_ar" == "true" ]]; then 
  # # Press X
    ydotool key 45:1 45:0
    sleep 0.5    
  fi
  if [[ "$cast_ot" == "true" ]]; then 
  # # Press C
    ydotool key 46:1 46:0
    sleep 0.5      
  fi
  if [[ "$cast_wp" == "true" ]]; then 
  # # Press V
    ydotool key 47:1 47:0
    sleep 0.5      
  fi      
}

action_bs() {
  local cast_far=${1:-true} # Full Adr Rush
  local cast_ar=${2:-false} # Adr Rush
  local cast_ot=${3:-false} # Over-Thrust
  local cast_wp=${4:-false} # Weapon-Perfection


  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  local BS_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("all-about-zeny")) | .workspace.id'`

  if [[ -z "$BS_WINDOW" ]]; then
    echo "Looks like no bragi running. Skipping role"
    return -1
  fi

  local YD_KEY=$((1+($BS_WINDOW)))

  if [[ (( "$WINDOW" -ne "$BS_WINDOW" )) ]]; then
    echo "alt tab back to BS: $(date)"
    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.5
  fi

  action_bs_buff   
}

