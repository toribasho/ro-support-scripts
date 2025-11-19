#!/bin/bash

action_brew() {
  echo type z| dotool
}

BREW_COUNT=$1
COUNTER=1

sleep 5

while true; do

  if (( $COUNTER > $BREW_COUNT )); then
    echo 'Done!'
    exit
  fi

  action_brew
  sleep 9

  COUNTER=$(( COUNTER +1 ))
done