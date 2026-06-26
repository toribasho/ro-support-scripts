#!/bin/bash

action_brew() {
  ydotool key 33:1 33:0
  sleep 0.3
  ydotool key 28:1 28:0
  sleep 0.2
  ydotool key 28:1 28:0
  sleep 0.2
}

BREW_COUNT=$1
COUNTER=1

while true; do

  if (( $COUNTER > $BREW_COUNT )); then
    echo 'Done!'
    exit
  fi

  action_brew
  sleep 0.1

  COUNTER=$(( COUNTER +1 ))
done
