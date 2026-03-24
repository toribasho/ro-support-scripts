#!/bin/bash

action_brew() {
  ydotool key 35:1 35:0
  sleep 0.3
  ydotool key 28:1 28:0
  sleep 0.5
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
