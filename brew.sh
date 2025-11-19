#!/bin/bash

action_brew() {
  echo type f| dotool
  sleep 0.01
  echo key enter enter| dotool
  #sleep 0.01
  # echo key enter| dotool
}

BREW_COUNT=$1
COUNTER=1

while true; do

  if (( $COUNTER > $BREW_COUNT )); then
    echo 'Done!'
    exit
  fi

  action_brew
  #sleep 0.1

  COUNTER=$(( COUNTER +1 ))
done