#!/bin/bash

main_role=`hyprctl clients -j | jq -r '.[] | select(.workspace.id == 3) | .title' | awk -F "|" '{print $1}'`

echo "Main role is $main_role"

ssh tiny-arch ~/Games/ro-support-bot/run.sh $main_role