#!/bin/bash

# --- Environment "Stealing" for SSH (Corrected Path) ---
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Define the runtime directory
    USER_ID=$(id -u)
    export XDG_RUNTIME_DIR="/run/user/$USER_ID"
    
    # Find the signature in the user-specific runtime path
    # We look for the directory that isn't 'hyprctl'
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | grep -v "hyprctl" | head -n 1)

    # For grim ( get pixel color ) i need to export WAYLAND_DISPALY
    export WAYLAND_DISPLAY="wayland-1"
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

convertToYdotool() {
    local input="${1,,}" # Convert input to lowercase to simplify lookup
    local sequence=""
    local len=${#input}

    # Loop through each character of the string
    for (( i=0; i<len; i++ )); do
        local char="${input:$i:1}"
        local code=""

        # Map characters to Linux keycodes
        case "$char" in
            a) code=30 ;; b) code=48 ;; c) code=46 ;; d) code=32 ;;
            e) code=18 ;; f) code=33 ;; g) code=34 ;; h) code=35 ;;
            i) code=23 ;; j) code=36 ;; k) code=37 ;; l) code=38 ;;
            m) code=50 ;; n) code=49 ;; o) code=24 ;; p) code=25 ;;
            q) code=16 ;; r) code=19 ;; s) code=31 ;; t) code=20 ;;
            u) code=22 ;; v) code=47 ;; w) code=17 ;; x) code=45 ;;
            y) code=21 ;; z) code=44 ;;
            1) code=2  ;; 2) code=3  ;; 3) code=4  ;; 4) code=5  ;;
            5) code=6  ;; 6) code=7  ;; 7) code=8  ;; 8) code=9  ;;
            9) code=10 ;; 0) code=11 ;;
            *) 
                echo "Error: Unsupported character '$char'" >&2
                return 1 
                ;;
        esac

        # Append the press (:1) and release (:0) sequence
        sequence+="${code}:1 ${code}:0 "
    done

    # Echo the final command string (trim trailing space)
    echo "ydotool key ${sequence% } -d 150"
}

openFriendList() {
  local X=822
  local Y=593
  local RGB_VALUES=$(grim -g "${X},${Y} 1x1" -t png - | magick - -format '%[fx:int(255*r)] %[fx:int(255*g)] %[fx:int(255*b)]' info:-)
  
  local TARGET_R=156
  local TARGET_G=181
  local TARGET_B=231

  local FriendList_Opened=false

  read R G B <<< "$RGB_VALUES"

  # Check if values exist (prevent errors if grim fails)
  if [[ -n "$R" && -n "$G" && -n "$B" ]]; then
      # Compare values
      if (( R == TARGET_R && G == TARGET_G && B == TARGET_B )); then
          echo "GOTCHA!"
          FriendList_Opened=true
      fi
  fi

  if [[ ! $FriendList_Opened ]]; then
    echo "Lest open friend list"
    ydotool key 56:1 
    sleep 0.1
    ydotool key 35:1 
    sleep 0.1
    ydotool key 56:0 35:0
    sleep 0.3
  fi    
}

#ydotool mousemove --absolute -x 600 -y 215 (+30)

launch_client() {
  # change wp
  switch_to_bottles

  # point
  local NUM=$1
  local ROLE_NAME=$2

  echo $(( 215+30*(($NUM-1)) ))
  ydotool mousemove --absolute -x 605 -y $((215+29*($NUM-1))) 
  sleep 0.1
  ydotool click 0xC0 -D 100
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
  ydotool click 0xC0 -D 100
  sleep 2

  # point to filter char list
  ydotool mousemove --absolute -x 305 -y 223
  # click
  ydotool click 0xC0 -D 100
  sleep 0.1

  if [[ $ROLE_NAME == "Linker" ]]; then
    # Light
    ydotool key 38:1 38:0 23:1 23:0 34:1 34:0 28:1 28:0 -d 150
  elif [[ $ROLE_NAME == "Bragi" ]]; then
    # Clampsi
    ydotool key 46:1 46:0 38:1 38:0 30:1 30:0 28:1 28:0 -d 150
  elif [[ $ROLE_NAME == "Prof" ]]; then
    # Naoo
    ydotool key 49:1 49:0 30:1 30:0 24:1 24:0 28:1 28:0 -d 150
  elif [[ $ROLE_NAME == "Alcaster" ]]; then
    # Alcaster
    ydotool key 30:1 30:0 38:1 38:0 46:1 46:0 28:1 28:0 -d 150
  elif [[ $ROLE_NAME == "All-about-zeny" ]]; then
    # all-about-zeny
    ydotool key 44:1 44:0 18:1 18:0 49:1 49:0 28:1 28:0 -d 150
  elif [[ $ROLE_NAME == "Kimichuri" ]]; then
    # Kimichuri bard
    $(convertToYdotool "chur")
  elif [[ $ROLE_NAME == "Dancer" ]]; then
    # Dance-till-Midnight
    $(convertToYdotool "till")  
  elif [[ $ROLE_NAME == "Shekvitelli" ]]; then
    # Shekvitelli - second linker
    $(convertToYdotool "shek")  
  else
    echo "Unknown param! "$NUM
  fi
  sleep 0.5
  ydotool key 28:1 28:0
  sleep 0.5
  ydotool key 28:1 28:0
  sleep 5

  ydotool click 0xC0 -D 100
  sleep 0.2

  ydotool key 28:1 28:0
  sleep 1
  ydotool key 28:1 28:0
  sleep 1
  # select char
  ydotool key 28:1 28:0
  sleep 1

  if [[ "$ROLE_NAME" == "Linker" || "$ROLE_NAME" == "Prof" ]]; then
    sleep 4
    openFriendList
  fi
}

# 2. Check if "All" is anywhere in the arguments
if [[ " $@ " =~ " Trio " ]]; then
  echo "All services selected."
  launch_client 1 "Linker"
  sleep 1
  launch_client 2 "Bragi"
  sleep 1
  launch_client 3 "Prof"
  exit 0
fi

# 3. Loop through all arguments ($@)
for arg in "$@"; do
    case "$arg" in
        "Linker")
            launch_client 1 $arg
            ;;
        "Bragi")
            launch_client 2 $arg
            ;;
        "Prof")
            launch_client 3 $arg
            ;;
        "Alcaster")
            launch_client 4 $arg
            ;;
        "All-about-zeny")
            launch_client 5 $arg
            ;;
        "Kimichuri")
            launch_client 4 $arg
            ;;
        "Dancer")
            launch_client 4 $arg
            ;;
        "Shekvitelli")
            launch_client 1 $arg
            ;;
        *)
            echo "Skipping unknown option: $arg"
            ;;
    esac
done

