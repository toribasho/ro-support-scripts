#!/bin/bash

# --- Configuration ---
# Define your predefined list of valid names here (space-separated)
PREDEFINED_ROLES=("all-about-zeny" "Toribash" "Junopie" "all-about-killing" "Torizavr" "HuntEmDown" "fear-no-more" "Futabuki")
STATE_FILE="/tmp/last_main_role.txt"

# --- Step 0: Load previously called main_role ---
if [[ -f "$STATE_FILE" ]]; then
    prev_main_role=$(cat "$STATE_FILE")
else
    prev_main_role=""
fi

# --- Step 1: Get active hyprland workspace aocli.exe title ---
# This fetches the title from the currently focused/active workspace
active_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

current_role=$(hyprctl clients -j | jq -r --arg active_wp "$active_workspace" '.[] | select(.workspace.id == ($active_wp|tonumber)) | select(.class == "aocli.exe") | .title' | awk -F "|" '{print $1}' | xargs)

echo 'Current role is: '$current_role

# Helper function to check if a value is in the predefined array
is_predefined() {
    local element
    for element in "${PREDEFINED_ROLES[@]}"; do
        if [[ "$element" == "$1" ]]; then
            return 0
        fi
    done
    return 1
}

# --- Logic Processing ---
main_role=""

# Step 2: If the current role is in the predefined list, use it
if [[ ! -z "$current_role" ]] && is_predefined "$current_role"; then
    echo '1'
    main_role="$current_role"

# Step 3: If not in the list, try to use the previously saved role
elif [[ ! -z "$prev_main_role" ]]; then
    echo '2'
    main_role="$prev_main_role"

# Step 4: Fallback to workspace 3 if previous role was empty
else
    echo '3'
    main_role=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id == 3) | select(.class == "aocli.exe") | .title' | awk -F "|" '{print $1}' | xargs)
fi

# --- Final Actions ---
echo "Main role is: $main_role"

if [[ -z "$main_role" ]]; then
    echo "No valid main role found. Exiting."
    exit 0
fi

# Save the successful main_role for the next execution (Step 0)
echo "$main_role" > "$STATE_FILE"

# Execute your SSH command
ssh tiny-arch ~/Games/ro-support-bot/run.sh "$main_role"