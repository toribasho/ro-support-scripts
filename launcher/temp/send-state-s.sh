#!/bin/bash

# mod, key, state, window

hyprctl dispatch sendkeystate , $1, down, class:arcadia-launcher.exe
sleep 0.01
hyprctl dispatch sendkeystate , $1, up, class:arcadia-launcher.exe
