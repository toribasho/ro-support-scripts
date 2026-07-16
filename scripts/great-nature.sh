#!/bin/bash

GN_COUNT=${1:-100}
COUNTER=1

sleep 2

action_enter() {
  ydotool key 28:1 28:0
  sleep 0.3
}

action_down() {
  ydotool key 108:1 108:0
  sleep 0.3
}


while true; do

  if (( $COUNTER > $GN_COUNT )); then
    echo 'Done!'
    exit
  fi

  ydotool click 0xC0
  sleep 1

  action_enter
  action_enter

  action_down
  action_enter

  action_enter
  # chose element:  [earth] water fire wind
  action_enter
  action_enter
  # chose count: 10
  ydotool key 2:1 2:0
  sleep 0.2
  ydotool key 11:1 11:0
  action_enter

  action_enter
  # rnd number: 1-9
  RND_NUM=$(((( RANDOM % 9 )) + 2)) # +1 for 1-9 range, +1 for keycode
  ydotool key $((RND_NUM)):1 $((RND_NUM)):0
  action_enter

  action_enter
  action_enter
  # done
  action_enter

  
  sleep 1

  COUNTER=$(( COUNTER +1 ))
done