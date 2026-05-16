#!/bin/bash

main_role=${1:-"none"}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# --- Environment "Stealing" for SSH (Corrected Path) ---
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Define the runtime directory
    USER_ID=$(id -u)
    export XDG_RUNTIME_DIR="/run/user/$USER_ID"
    
    # Find the signature in the user-specific runtime path
    # We look for the directory that isn't 'hyprctl'
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | grep -v "hyprctl" | head -n 1)
fi

# global roles with call-actions
source "$SCRIPT_DIR/roles/linker.sh"
source "$SCRIPT_DIR/roles/bragi.sh"
source "$SCRIPT_DIR/roles/bs.sh"
source "$SCRIPT_DIR/roles/prof.sh"
source "$SCRIPT_DIR/roles/alchemist.sh"

source "$SCRIPT_DIR/buffer.config"

case "$main_role" in
  "all-about-zeny")
    action_bard 
    action_link "ms" $ms_link_slot
    action_prof $ms_prof_slot
    ;;
  "Toribash")
    action_bard 
    action_link "ms" $ms_link_slot
    action_link "rogue" $rogue_link_slot
    action_bs
    ;;
  "Junopie")
    action_bard 
    action_link "ass" $junopie_link_slot
    action_prof $junopie_prof_slot
    ;;  
  "all-about-killing")
    action_bard 
    action_link "ass" $killing_link_slot
    action_prof $killing_prof_slot
    ;;
  "Torizavr")
    action_bard 
    action_prof $champ_prof_slot
    ;;        
  "HuntEmDown")
    action_bard 
    action_prof $hunt_prof_slot
    ;;                          
  *) 
    echo "Unknown role"
    notify-send "Unknown Link role: $main_role"
    ;;
esac

  # "sage")
  #   action_link_sage $slot
  #   action_alch 
  #   ;;
  # "Torizavr")
  #   action_prof $prof_champ_slot
  #   ;;    
  # "alch")
  #   action_link_alch $slot
  #   ;;  
