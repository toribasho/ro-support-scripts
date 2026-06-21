#!/bin/bash

main_role=`hyprctl clients -j | jq -r '.[] | select(.workspace.id == 3) | select(.class == "aocli.exe") | .title' | awk -F "|" '{print $1}'`

echo "Main role is $main_role"

if [[ -z "$main_role" ]]; then
    exit 0
fi

ssh tiny-arch ~/Games/ro-support-bot/run.sh $main_role