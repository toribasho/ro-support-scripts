#!/bin/bash

# --- Configuration & State Setup ---
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/start-trio-selection"

# 1. Define explicit preset mappings using an associative array
declare -A presets
presets["Trio"]="Linker Bragi Prof"
presets["All-about-zeny"]="Dancer Alcaster Kimichuri"
presets["Shekvitelli"]="Linker Dancer Prof"

# 2. List of all available individual accounts
accounts=("Linker" "Bragi" "Prof" "Dancer" "Alcaster" "Kimichuri")

# Order of preset keys for the left column
preset_keys=("Trio" "All-about-zeny" "Shekvitelli")

# Load last selection if available, default to "Trio"
if [[ -f "$CACHE_FILE" ]]; then
    mapfile -t selected < "$CACHE_FILE"
else
    selected=("Trio")
fi

host=$(cat /etc/hostname 2>/dev/null)

while true; do
    # Build interleaved 2-column list (Presets on left, Accounts on right)
    menu_list=""
    max_rows=$(( ${#preset_keys[@]} > ${#accounts[@]} ? ${#preset_keys[@]} : ${#accounts[@]} ))

    for ((i=0; i<max_rows; i++)); do
        # Left column (Preset)
        if [[ $i -lt ${#preset_keys[@]} ]]; then
            p="${preset_keys[$i]}"
            if [[ " ${selected[*]} " =~ " $p " ]]; then
                menu_list+="[x] Preset: $p\t"
            else
                menu_list+="[ ] Preset: $p\t"
            fi
        else
            menu_list+="\t"
        fi

        # Right column (Account)
        if [[ $i -lt ${#accounts[@]} ]]; then
            a="${accounts[$i]}"
            if [[ " ${selected[*]} " =~ " $a " ]]; then
                menu_list+="[x] $a\n"
            else
                menu_list+="[ ] $a\n"
            fi
        else
            menu_list+="\n"
        fi
    done

    menu_list+="CONFIRM"

    # Launch Rofi (2 columns)
    choice=$(echo -e "$menu_list" | rofi -dmenu -i -p "Selection" \
        -kb-custom-1 "space" \
        -theme-str 'window { width: 550px; } mainbox { children: [listview]; } listview { columns: 2; lines: '$((max_rows + 1))'; }')
    
    exit_code=$?
    [[ $exit_code -eq 1 ]] && exit 0

    clean_choice=$(echo "$choice" | sed -E 's/\[.\] (Preset: )?//; s/\t//g')

    # Confirm & Launch
    if [[ "$clean_choice" == "CONFIRM" || $exit_code -eq 0 ]]; then
        # Save exact selection state to cache
        printf "%s\n" "${selected[@]}" > "$CACHE_FILE"

        # Expand presets into explicit account lists before passing to launcher
        final_launch_list=()
        for item in "${selected[@]}"; do
            if [[ -n "${presets[$item]}" ]]; then
                # Add all mapped characters from preset
                read -ra mapped <<< "${presets[$item]}"
                final_launch_list+=("${mapped[@]}")
            else
                # Add individual account
                final_launch_list+=("$item")
            fi
        done

        # De-duplicate entries in case of overlapping choices
        read -ra final_launch_list <<< "$(printf "%s\n" "${final_launch_list[@]}" | sort -u | tr '\n' ' ')"

        echo "Launching accounts: ${final_launch_list[*]}"

        if [[ "$host" == "arch-legion" ]]; then
            ssh tiny-arch "~/Games/launcher/start-trio.sh ${final_launch_list[*]}"
        elif [[ "$host" == "tiny-arch" ]]; then
            ~/Games/launcher/start-trio.sh "${final_launch_list[@]}"
        else
            echo "Undefined host: '$host'. Aborting..."
        fi
        break
    fi

    # Toggle preset choice
    if [[ -n "${presets[$clean_choice]}" ]]; then
        if [[ " ${selected[*]} " =~ " ${clean_choice} " ]]; then
            selected=()
        else
            selected=("$clean_choice")
        fi
    else
        # Remove preset selections when picking individual accounts manually
        new_selected=()
        for s in "${selected[@]}"; do
            if [[ -z "${presets[$s]}" ]]; then
                new_selected+=("$s")
            fi
        done
        selected=("${new_selected[@]}")

        # Toggle account item
        if [[ " ${selected[*]} " =~ " ${clean_choice} " ]]; then
            temp=()
            for s in "${selected[@]}"; do
                [[ "$s" != "$clean_choice" ]] && temp+=("$s")
            done
            selected=("${temp[@]}")
        else
            selected+=("$clean_choice")
        fi
    fi
done