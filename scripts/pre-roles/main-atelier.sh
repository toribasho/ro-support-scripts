#!/bin/bash

# Path to the timestamp file
TIMESTAMP_FILE="/tmp/.last_bragi_timestamp"
TIMESTAMP_A_FILE="/tmp/.last_bers_timestamp"
ALTTAB_DELAY=0.5
SKILL_DELAY=0.3

LINK_SLOT=4
PROF_SLOT=4

RERUN=false
#RERUN=true

WINDOW=4

### BRIEF ###
# BS at 2nd slot
# #####
#
# RUN convert SP after exchange
CONVERT=true

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
  sleep 0.5
  # echo type x| dotool
  # sleep 0.3
  # W Perfection
  #echo type c| dotool
  #ydotool key 46:1 46:0
  sleep 0.5

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
    sleep 0.5
    WINDOW=2
  fi

  # press Q for BS link
  #echo type q| dotool
  ydotool key 16:1 16:0
  sleep 0.3

  # move to 2nd slot
  # win at right bottom
  ydotool mousemove --absolute -x 423 -y 248 
  # win at mid left top
  #ydotool mousemove --absolute -x 190 -y 140
  sleep 0.3

  # click on BS
  ydotool click 0xC0;
  sleep 0.3
}

action_bragi() {
  
  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "Bragi: $(date)"

  #echo type z| dotool
  ydotool key 30:1 30:0
  sleep 0.5
}

action_bragi_new() {

  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  echo "Bragi: $(date)"

  # W for bragi
  ydotool key 17:1 17:0
  sleep 0.5
}

action_cancel_bragi() {
  if [[ (( "$WINDOW" -ne 3 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 4:1 125:0 4:0
    sleep 0.5
    WINDOW=3
  fi

  # swap wep for cancel Z-X
  ydotool key 44:1 44:0
  sleep 0.5
  ydotool key 45:1 45:0
  sleep 0.3
}

action_service() {
  
  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt tab back to BS: $(date)"
    ydotool key 125:1 3:1 125:0 3:0
    sleep 0.5
    WINDOW=2
  fi

  # A - for Encore
  echo "Service: $(date)"
  ydotool key 30:1 30:0
  sleep 0.5
}

action_service_new() {

  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 3:1 125:0 3:0
    sleep 0.5
    WINDOW=2
  fi

  echo "Service: $(date)"
  # W for service
  ydotool key 17:1 17:0
  sleep 0.5
}

action_cancel_service() {
  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt tab back to BS: $(date)"
    #echo key Super+3 | dotool
    ydotool key 125:1 3:1 125:0 3:0
    sleep 0.5
    WINDOW=2
  fi

  # swap wep for cancel Z-X
  ydotool key 44:1 44:0
  sleep 0.5
  ydotool key 45:1 45:0
  sleep 0.3
}

action_link_ass() {
  echo "Link BS: $(date)"

  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt + tab to linker: $(date)"
    #echo key Super+2 | dotool
    ydotool key 125:1 3:1 125:0 3:0
    sleep 0.5
    WINDOW=2
  fi

  # press D for ass link
  ydotool key 32:1 32:0
  sleep 0.3

  # move to 1st slot
  # win at right bottom
  ydotool mousemove --absolute -x 423 -y 236
  # 4th slot
  #ydotool mousemove --absolute -x 423 -y 271
  # win at mid left top
  #ydotool mousemove --absolute -x 190 -y 140
  sleep 0.3

  # click on BS
  ydotool click 0xC0;
  sleep 0.3
}

action_link_alch() {
  echo "Link ALCH: $(date)"

  if [[ (( "$WINDOW" -ne 2 )) ]]; then
    echo "alt + tab to linker: $(date)"
    #echo key Super+2 | dotool
    ydotool key 125:1 3:1 125:0 3:0
    sleep 0.3
    WINDOW=2
  fi

  # press a for Alchemist link
  #echo type a| dotool
  ydotool key 30:1 30:0
  sleep 0.5

  # move to 5th slot on right bottom
  ydotool mousemove --absolute -x 423 -y 282
  sleep 0.5

  # click on char
  ydotool click 0xC0;
  sleep 0.5
}

action_throw_bers() {
  echo "Throw bers from Alch: $(date)"

  if [[ (( "$WINDOW" -ne 4 )) ]]; then
    echo "alt + tab to Alch: $(date)"
    #echo key Super+4 | dotool
    ydotool key 125:1 5:1 125:0 5:0
    sleep 0.3
    WINDOW=4
  fi

  # press x for Bererk Pot Pitcher
  ydotool key 45:1 45:0
  sleep 0.5

  # move to 4th slot on right bottom
  ydotool mousemove --absolute -x 423 -y 270
  sleep 0.5

  # click on sage
  ydotool click 0xC0;
  sleep 0.5
}

action_prof() {

  if [[ (( "$WINDOW" -ne 4 )) ]]; then
    echo "alt tab back to Prof: $(date)"
    ydotool key 125:1 5:1 125:0 5:0
    sleep 0.5
    WINDOW=4
  fi

  echo "Prof: $(date)"

  # Z for Soul exchange
  ydotool key 44:1 44:0

  # move to 1st slot on right bottom
  ydotool mousemove --absolute -x 423 -y 236
  # 2nd
  #ydotool mousemove --absolute -x 423 -y 248
  # 3rd
  #ydotool mousemove --absolute -x 423 -y 260
  # 4th
  #ydotool mousemove --absolute -x 423 -y 271
  # 5th
  #ydotool mousemove --absolute -x 423 -y 282
  sleep 0.5

  # click 
  ydotool click 0xC0;
  sleep 0.5

  if [[ "$CONVERT" == "true" ]]; then
    sleep 2
    # sp conversion 4 times for 1.6k sp
    ydotool key 45:1 45:0
    sleep 0.6
    ydotool key 45:1 45:0
    sleep 0.6
    ydotool key 45:1 45:0
    sleep 0.6
    ydotool key 45:1 45:0
    sleep 0.6
  fi
}


# SECTION FOR Bragi ONCE IN 3 MIN
if [ ! -f "$TIMESTAMP_FILE" ]; then
  touch "$TIMESTAMP_FILE"
  date +%s > "$TIMESTAMP_FILE"  # Store the current epoch time
  action_bragi_new
  action_service_new
fi

last_run=$(cat "$TIMESTAMP_FILE")
current_time=$(date +%s)
time_diff=$((current_time - last_run))

if (( time_diff > 6000 )); then  # 6000 seconds = 100 minutes
  action_bragi_new
  action_service_new
  # Update the timestamp after Action 2 is executed
  date +%s > "$TIMESTAMP_FILE"
elif (( time_diff > 70 )); then  # 170 seconds = < 3 minutes
  action_cancel_bragi
  action_bragi
  action_cancel_service
  action_service
  # Update the timestamp after Action 2 is executed
  date +%s > "$TIMESTAMP_FILE"
else
  echo "Skipping Action BS LINK. Only $(($time_diff / 60)) minutes and $((time_diff % 60)) seconds have passed."
fi
############ END ##################

# SECTION FOR ALCH LINK + BERS ONCE IN 12 MIN
if [ ! -f "$TIMESTAMP_A_FILE" ]; then
  touch "$TIMESTAMP_A_FILE"
  date +%s > "$TIMESTAMP_A_FILE"  # Store the current epoch time
  sleep 2
  #action_link_alch
  #action_throw_bers
fi

last_run_a=$(cat "$TIMESTAMP_A_FILE")
current_time_a=$(date +%s)
time_diff_a=$((current_time_a - last_run_a))


if (( time_diff_a > 750 )); then  # 750 seconds = 12.5 minutes
  #action_link_alch
  #action_throw_bers
  # Update the timestamp after Action 2 is executed
  date +%s > "$TIMESTAMP_A_FILE"
else
  echo "Skipping Action Alch LINK + BERS. Only $(($time_diff_a / 60)) minutes and $((time_diff_a % 60)) seconds have passed."
fi

############ END ##################

# cast every time
#action_link_ass
action_prof

#action_link_rogue
#action_link_sage
#action_bs_buff


