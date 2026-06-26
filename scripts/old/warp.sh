#!/bin/bash

while true; do
  echo type z| dotool
  # Generate a random number between 20 and 40 (inclusive)
  random_sleep=$(( (RANDOM % 12) + 14 ))  # 21 because we want 20-40 inclusive

  echo "Sleeping for $random_sleep seconds..." # Optional: Print the sleep time

  sleep $random_sleep
done
