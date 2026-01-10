#!/bin/bash

# --- CONFIGURATION ---
X=1035
Y=559
TARGET_R=180
TARGET_G=180
TARGET_B=180
DELAY=0.1
TARGET_CATCH=1000
CURRENT_CATCH=1
# ---------------------
QUIT_AFTER_FINISH=false

echo "Monitoring $X,$Y for RGB > ($TARGET_R,$TARGET_G,$TARGET_B)..."


sleep 2

FISHING=false

while true; do

    if [[ "$FISHING" == "false" ]]; then 
        ydotool click 0xC0
        sleep 1

        ydotool key 28:1 28:0
        sleep 0.8

        ydotool key 28:1 28:0
        sleep 0.8

        FISHING=true
    fi

    # Get RGB values as space-separated integers (e.g., "255 10 50")
    RGB_VALUES=$(grim -g "${X},${Y} 1x1" -t png - | magick - -format '%[fx:int(255*r)] %[fx:int(255*g)] %[fx:int(255*b)]' info:-)

    # Read them into variables
    read R G B <<< "$RGB_VALUES"

    # Check if values exist (prevent errors if grim fails)
    if [[ -n "$R" && -n "$G" && -n "$B" ]]; then
        # Compare values
        if (( R >= TARGET_R && G >= TARGET_G && B >= TARGET_B )); then
            echo "GOTCHA!"
            
            ydotool key 28:1 28:0
            sleep 1

            ydotool key 28:1 28:0
            sleep 1.6

            ydotool key 28:1 28:0
            sleep 1            

            FISHING=false

            echo "Catched "$CURRENT_CATCH

            CURRENT_CATCH=$(( CURRENT_CATCH + 1 ))

            # break # Remove this line if you want it to keep looping
        fi
    fi

    if (( CURRENT_CATCH > TARGET_CATCH )); then
        echo 'Done!'
        break
    fi

    sleep $DELAY
done

if [[ "$QUIT_AFTER_FINISH" == "true" ]]; then
    ydotool key 56:1 16:1 56:0 16:0
    sleep 1
fi
