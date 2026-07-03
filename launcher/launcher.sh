#!/bin/bash

# Configuration
options=("Trio" "Linker" "Bragi" "Prof" "Dancer" "Alcaster" "All-about-zeny" "Kimichuri" )
selected=("Trio")

host=$(cat /etc/hostname)

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
        if [[ "$host" == "arch-legion" ]]; then
            ssh tiny-arch "~/Games/launcher/start-trio.sh ${selected[*]}"
        elif [[ "$host" == "tiny-arch" ]]; then
            ~/Games/launcher/start-trio.sh ${selected[*]}
        else
            echo "Undefined host. Aborting...\nCheck /etc/hostname"
        fi
        break
    fi

    # 3. Toggle Logic with "Trio" behavior
    if [[ "$clean_choice" == "Trio" ]]; then
        # If "Trio" is picked, clear everything else and just keep "Trio"
        if [[ " ${selected[*]} " =~ " Trio " ]]; then
            selected=()
        else
            selected=("Trio")
        fi
    else
        # If a regular option is picked:
        # a) Remove "Trio" from the list (since we are picking specifics)
        selected=(${selected[@]/Trio/})

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
