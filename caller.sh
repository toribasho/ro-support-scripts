#!/bin/bash

main_role=`hyprctl clients -j | jq -r '.[] | select(.workspace.id == 3) | .title' | awk -F "|" '{print $1}'`

ssh tity-arch ~/Games/ro-support-bot/run.sh $main_role