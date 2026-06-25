#!/bin/bash

# --- Environment "Stealing" for SSH (Corrected Path) ---
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Define the runtime directory
    USER_ID=$(id -u)
    export XDG_RUNTIME_DIR="/run/user/$USER_ID"
    
    # Find the signature in the user-specific runtime path
    # We look for the directory that isn't 'hyprctl'
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | grep -v "hyprctl" | head -n 1)
fi

# 1. Check if locked
if pgrep -x "hyprlock" > /dev/null; then
    echo "System is locked. Initiating smart unlock..."
    
    # 2. Check if display is off, turn it on if necessary
    if hyprctl monitors -j | jq -e '.[] | select(.dpmsStatus == false)' > /dev/null; then
        hyprctl dispatch dpms on
        # lua variant
        # hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
        sleep 0.1 # Small buffer for the hardware to respond
    fi
    
    # 3. Gracefully dismiss hyprlock
    pkill -USR1 hyprlock

    # wit for wakeup
    sleep 3
else
    echo "System is already unlocked. No action needed."
fi

BOTTLES_WP=10
CURRENT_WP=`hyprctl activeworkspace -j | jq '.id'`
FriendList_Open=true
BOTTLES_WP_ID=$((1+$BOTTLES_WP))
FIRST_RUN=true

switch_to_bottles() {
  if [[ (( `hyprctl activeworkspace -j | jq '.id'` -ne $BOTTLES_WP )) ]]; then
    echo "alt tab to Bottles: $(date)"
    ydotool key 125:1 $((BOTTLES_WP_ID)):1 125:0 $((BOTTLES_WP_ID)):0
    sleep 0.5
  fi
}

#ydotool mousemove --absolute -x 600 -y 215 (+30)

launch_client() {
  # change wp
  switch_to_bottles

  # point
  local NUM=$1
  echo $(( 215+30*(($NUM-1)) ))
  ydotool mousemove --absolute -x 600 -y $((215+30*($NUM-1))) 
  sleep 0.1
  ydotool click 0xC0;
  sleep 0.1

  # switch to workspace
  local WP=$(( 2+$NUM ))
  ydotool key 125:1 $((WP)):1 125:0 $((WP)):0
  
  # wait for laucher
  sleep 10
  if (( $FIRST_RUN == "true" )); then
    sleep 3
    FIRST_RUN=false
  fi

  # point to login btn
  ydotool mousemove --absolute -x 305 -y 165
  sleep 0.1
  ydotool click 0xC0;
  sleep 2

  # point to filter char list
  ydotool mousemove --absolute -x 305 -y 223
  # click
  ydotool click 0xC0;
  sleep 0.1

  if (( $NUM == 1 )); then
    # Light
    ydotool key 38:1 38:0 23:1 23:0 34:1 34:0 28:1 28:0
  elif (( $NUM == 2 )); then
    # Clampsi
    ydotool key 46:1 46:0 38:1 38:0 30:1 30:0 28:1 28:0
  elif (( $NUM == 3 )); then
    # Naoo
    ydotool key 49:1 49:0 30:1 30:0 24:1 24:0 28:1 28:0
  elif (( $NUM == 4 )); then
    # Alcaster
    ydotool key 30:1 30:0 38:1 38:0 46:1 46:0 28:1 28:0
  elif (( $NUM == 5 )); then
    # Alcaster
    ydotool key 44:1 44:0 18:1 18:0 49:1 49:0 28:1 28:0
  else
    echo "Unknown param! "$NUM
  fi
  ydotool key 28:1 28:0
  sleep 5

  ydotool click 0xC0
  sleep 0.2

  ydotool key 28:1 28:0
  sleep 1
  ydotool key 28:1 28:0
  sleep 1
  # select char
  ydotool key 28:1 28:0
  sleep 1

  if [[ "$NUM" == 1 || "$NUM" == 3 ]]; then
    sleep 4
    echo "Lest open friend list"
    ydotool key 56:1 35:1 56:0 35:0
    sleep 0.3
  fi
}

# 2. Check if "All" is anywhere in the arguments
if [[ " $@ " =~ " Trio " ]]; then
  echo "All services selected."
  launch_client 1 
  sleep 1
  launch_client 2
  sleep 1
  launch_client 3 
  exit 0
fi

# 3. Loop through all arguments ($@)
for arg in "$@"; do
    case "$arg" in
        "Linker")
            launch_client 1 
            ;;
        "Bragi")
            launch_client 2
            ;;
        "Prof")
            launch_client 3 
            ;;
        "Alcaster")
            launch_client 4 
            ;;
        "All-about-zeny")
            launch_client 5
            ;;            
        *)
            echo "Skipping unknown option: $arg"
            ;;
    esac
done

