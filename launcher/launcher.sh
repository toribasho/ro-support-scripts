#!/bin/bash

# Initial state
options=("Option 1" "Option 2" "Option 3")
selected=()

while true; do
    # Generate the list with [x] or [ ]
    menu_list=""
    for opt in "${options[@]}"; do
        if [[ " ${selected[*]} " =~ " ${opt} " ]]; then
            menu_list+="[x] $opt\n"
        else
            menu_list+="[ ] $opt\n"
        fi
    done
    menu_list+="DONE"

    # Launch Rofi
    choice=$(echo -e "$menu_list" | rofi -dmenu -i -p "Settings" \
        -kb-custom-1 "space" \
        -theme-str 'mainbox { children: [listview]; }')
    
    # Exit codes: 0 is Enter, 1 is Escape, 10 is our Custom Space key
    exit_code=$?

    if [ $exit_code -eq 1 ]; then
        exit 0 # User pressed Escape
    fi

    clean_choice=$(echo "$choice" | sed 's/\[.\] //')

    if [ "$clean_choice" == "DONE" ] || [ $exit_code -eq 0 ]; then
        # Process the final 'selected' array here
        echo "Final selections: ${selected[*]}"
        break
    fi

    # Toggle logic: If it's in the array, remove it. If not, add it.
    if [[ " ${selected[*]} " =~ " ${clean_choice} " ]]; then
        selected=(${selected[@]/${clean_choice}/})
    else
        selected+=("$clean_choice")
    fi
done
