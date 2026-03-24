#!/bin/bash

# Configuration
options=("All" "Linker" "Bragi" "Prof" "Alcaster")
selected=("All")

while true; do
    # 1. Prepare the menu list with [x] or [ ]
    menu_list=""
    for opt in "${options[@]}"; do
        if [[ " ${selected[*]} " =~ " ${opt} " ]]; then
            menu_list+="[x] $opt\n"
        else
            menu_list+="[ ] $opt\n"
        fi
    done
    menu_list+="CONFIRM"

    # 2. Launch Rofi (using the lowercase 'space' fix)
    choice=$(echo -e "$menu_list" | rofi -dmenu -i -p "Selection" \
        -kb-custom-1 "space" \
        -theme-str 'mainbox { children: [listview]; }')
    
    exit_code=$?

    # Exit if User presses Escape
    [[ $exit_code -eq 1 ]] && exit 0

    # Clean the [x] or [ ] prefix
    clean_choice=$(echo "$choice" | sed 's/\[.\] //')

    # If User hits Enter or clicks CONFIRM, finish and output
    if [[ "$clean_choice" == "CONFIRM" || $exit_code -eq 0 ]]; then
        echo "Final selections: ${selected[*]}"
        echo ssh tinny-arch ~/Games/launcher/start-trio.sh ${selected[*]}
        break
    fi

    # 3. Toggle Logic with "All" behavior
    if [[ "$clean_choice" == "All" ]]; then
        # If "All" is picked, clear everything else and just keep "All"
        if [[ " ${selected[*]} " =~ " All " ]]; then
            selected=()
        else
            selected=("All")
        fi
    else
        # If a regular option is picked:
        # a) Remove "All" from the list (since we are picking specifics)
        selected=(${selected[@]/All/})

        # b) Toggle the current choice
        if [[ " ${selected[*]} " =~ " ${clean_choice} " ]]; then
            # Remove it if it exists
            new_selected=()
            for s in "${selected[@]}"; do
                [[ "$s" != "$clean_choice" ]] && new_selected+=("$s")
            done
            selected=("${new_selected[@]}")
        else
            # Add it if it doesn't
            selected+=("$clean_choice")
        fi
    fi
done
