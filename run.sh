#!/bin/bash

main_role=${1:-"none"}

# global roles with call-actions
source ./roles/linker.sh
source ./roles/bragi.sh
source ./roles/bs.sh
source ./roles/prof.sh
source ./roles/alch.sh

source buffer.config

case "$main_role" in
  "all-about-zeny")
    action_bard 
    action_link "ms" $ms_link_slot
    action_prof $ms_prof_slot
    ;;
  "Toribash")
    action_bard 
    action_prof $prof_rogue_slot
    action_link "ms" $ms_link_slot
    action_link $main_role $rogue_link_slot
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
  *) 
    echo "Unknown role"
    notify-send (("Unknown Link role: $main_role"))
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
