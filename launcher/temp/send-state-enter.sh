#!/bin/bash

# mod, key, state, window

hyprctl dispatch sendkeystate , enter, down, class:arcadia-launcher.exe
sleep 0.05
hyprctl dispatch sendkeystate , enter, up, class:arcadia-launcher.exe
