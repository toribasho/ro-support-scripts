#!/bin/bash

hyprctl dispatch focuswindow class:arcadia-launcher.exe
sleep 1
hyprctl dispatch sendkeystate , enter, down, class:arcadia-launcher.exe
sleep 0.05
hyprctl dispatch sendkeystate , enter, up, class:arcadia-launcher.exe
