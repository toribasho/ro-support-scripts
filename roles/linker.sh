#!/bin/bash

# Main function is action_link() in the bottom
# works via friend lsit order
# Specify:
# 1 - role
# 2 - slot



action_link_bs() {
  local slot=${1:-2}

  echo "Link BS: $(date)"

  # press Q for BS link
  ydotool key 16:1 16:0
  sleep 0.3

  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $(((224)+12*($slot-1)))
  sleep 0.3

  # click on BS
  ydotool click 0xC0;
  sleep 0.3
}

action_link_rogue() {
  local slot=${1:-1}

  echo "Link ROGUE: $(date)"

  # press w for Rogue link
  ydotool key 17:1 17:0
  sleep 0.3

  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $(((224)+12*($slot-1)))
  sleep 0.3

  # click on Rogue
  ydotool click 0xC0;
  sleep 0.3
}

action_link_sage() {
  local slot=${1:-4}

  echo "Link SAGE: $(date)"

  # press w for Rogue link
  ydotool key 19:1 19:0
  sleep 0.3

  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $(((224)+12*($slot-1)))
  sleep 0.3

  # click on sage
  ydotool click 0xC0;
  sleep 0.3
}

action_link_alch() {
  local slot=${1:-5}

  echo "Link ALCH: $(date)"

  # press a for Alchemist link
  ydotool key 30:1 30:0
  sleep 0.3

  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $(((224)+12*($slot-1)))
  sleep 0.3

  # click on char
  ydotool click 0xC0;
  sleep 0.3
}

action_link_ass() {
  local slot=${1:-3}

  echo "Link aSS: $(date)"

  # press D for ass link
  ydotool key 32:1 32:0
  sleep 0.3


  # move to slot on right bottom
  ydotool mousemove --absolute -x 423 -y $(((224)+12*($slot-1)))
  sleep 0.3

  # click
  ydotool click 0xC0;
  sleep 0.3
}

action_link() {
  local role=${1:-"none"}
  local slot=${2:-1}

  local WINDOW=`hyprctl activeworkspace -j | jq '.id'`
  local LINK_WINDOW=`hyprctl clients -j | jq -r '.[] | select(.class == "steam_proton") | select(.title | test("Light-the-Star")) | .workspace.id'`
  
  if [[ -z "$LINK_WINDOW" ]]; then
    echo "Looks like no linker running. Skipping role"
    return -1
  fi  

  local YD_KEY=$((1+($LINK_WINDOW)))

  if [[ (( "$WINDOW" -ne "$LINK_WINDOW" )) ]]; then
    echo "alt + tab to linker: $(date)"
    ydotool key 125:1 $((YD_KEY)):1 125:0 $((YD_KEY)):0
    sleep 0.2
  fi  

  case "$role" in
  "ms")
    action_link_bs $slot
    ;;
  "rogue")
    action_link_rogue $slot
    ;;
  "sage")
    action_link_sage $slot
    ;;
  "alch")
    action_link_alch $slot
    ;;
  "ass")
    action_link_ass $slot
    ;;               
  *) 
    echo "Unknown role"
    notify-send $(("Unknown Link role: $role with slot $slot"))
    ;;
  esac

}