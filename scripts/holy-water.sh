#!/bin/bash

action_brew() {
  ydotool key 50:1 50:0
}

BREW_COUNT=$1
COUNTER=1

sleep 2

while true; do

  if (( $COUNTER > $BREW_COUNT )); then
    echo 'Done!'
    exit
  fi

  action_brew
  sleep 1

  COUNTER=$(( COUNTER +1 ))
done
