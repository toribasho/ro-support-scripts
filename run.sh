#!/bin/bash

main_role=${1:-"none"}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
# follow=true
#HuntWithService=true

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
source "$SCRIPT_DIR/roles/service.sh"
source "$SCRIPT_DIR/roles/bs.sh"
source "$SCRIPT_DIR/roles/prof.sh"
source "$SCRIPT_DIR/roles/alchemist.sh"
# friend list order & global function
source "$SCRIPT_DIR/buffer.config"

check_for_bot

case "$main_role" in
  "all-about-zeny")
    if [[ -n `check_for_role "bard"` ]]; then
      action_bard 
    fi
    action_link "ms" $ms_link_slot
    action_prof $ms_prof_slot
    ;;
  "Toribash")
    action_bard 
    action_link "rogue" $rogue_link_slot
    if [[ -n `check_for_role "ms"` ]]; then
      action_link "ms" $ms_link_slot
      action_bs true false false true
    fi
    ;;
  "Junopie")
    action_bard 
    action_link "ass" $junopie_link_slot
    action_prof $junopie_prof_slot
    ;;  
  "all-about-killing")
    action_bard
    if [[ -n `check_for_role "linker"` ]]; then
      action_link "ass" $killing_link_slot
    fi
    action_prof $killing_prof_slot true 1 true
    ;;
  "Torizavr")
  use_indugle=true
    if [[ -n `check_for_role "bard"` ]]; then
      action_bard 
      use_indugle=false
    fi
    if [[ $use_indugle == true ]]; then
      action_prof $champ_prof_slot true 5
    else
      action_prof $champ_prof_slot
    fi
    ;;        
  "HuntEmDown")
    echo 'FLAG IS: '$HuntWithService
    if [[ -n $follow && $follow == true ]]; then
      local force=true   
      action_bard $force
      if [[ -n `check_for_role "dancer"` ]]; then
        action_dancer $force
      fi
      if [[ -n `check_for_role "prof"` ]]; then
        action_prof $hunt_prof_slot true 1 true
      fi   
    elif [[ "$HuntWithService" == true ]]; then
      echo 'GO FOLLOW'
      action_prof $hunt_prof_slot false 1 true
    else
      action_bard
      action_prof $hunt_prof_slot true 1
    fi
    ;;               
  "Zingal")
    action_bard 
    ;;            
  "fear-no-more")
    action_prof $abra_prof_slot true 3
    ;;                
  "Kimichani")
    action_bard 
    action_prof 8 true 1
    ;;            
  "Futabuki")
    action_bard 
    action_link "crus" $crus_link_slot
    action_prof $crus_prof_slot
    ;;
  "Marques")
    action_prof $marques_prof_slot true 3
    ;;    
  "Dance-till-Midnight")
    action_bard 
    action_prof $dancer_prof_slot
    ;;                        
  *) 
    echo "Unknown role"
    # action_bard 
    # action_prof 6
    echo "Unknown role"
    notify-send "Unknown Link role: $main_role"
    ;;
esac

call_the_bot

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
