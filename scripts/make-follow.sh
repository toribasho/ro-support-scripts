#!/bin/bash

ydotool mousemove --absolute -x 255 -y 160
ydotool key 54:1
sleep 0.1
echo "right_click" > /tmp/vmouse_cmd
sleep 0.3
ydotool key 54:0