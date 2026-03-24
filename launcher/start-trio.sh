BOTTLES_WP=5
CURRENT_WP=`hyprctl activeworkspace -j | jq '.id'`
TTG_Start=true

switch_to_bottles() {
  if [[ (( `hyprctl activeworkspace -j | jq '.id'` -ne 5 )) ]]; then
    echo "alt tab to Bottles: $(date)"
    ydotool key 125:1 6:1 125:0 6:0
    sleep 0.5
    CURRENT_WP=5
  fi
}

#ydotool mousemove --absolute -x 600 -y 215 (+30)

launch_client() {
  # change wp
  switch_to_bottles

  # point
  local NUM=$1
  echo $(( 215+30*(($NUM-1)) ))
  ydotool mousemove --absolute -x 600 -y $((215+30*($NUM-1))) 
  sleep 0.1
  ydotool click 0xC0;
  sleep 0.1

  # switch to workspace
  local WP=$(( 2+$NUM ))
  ydotool key 125:1 $((WP)):1 125:0 $((WP)):0
  
  # wait for laucher
  sleep 10

  # point to login btn
  ydotool mousemove --absolute -x 305 -y 165
  sleep 0.1
  ydotool click 0xC0;
  sleep 2

  # point to filter char list
  ydotool mousemove --absolute -x 305 -y 223
  # click
  ydotool click 0xC0;
  sleep 0.1

  if (( $NUM == 1 )); then
    # Light
    ydotool key 38:1 38:0 23:1 23:0 34:1 34:0 28:1 28:0
  elif (( $NUM == 2 )); then
    # Clampsi
    ydotool key 46:1 46:0 38:1 38:0 30:1 30:0 28:1 28:0
  elif (( $NUM == 3 )); then
    # Naoo
    ydotool key 49:1 49:0 30:1 30:0 24:1 24:0 28:1 28:0
  else
    echo "Unknown param! "$NUM
  fi
  ydotool key 28:1 28:0
  sleep 5

  ydotool key 28:1 28:0
  sleep 1
  ydotool key 28:1 28:0
  sleep 1
  if (( $TTG_Start == "true" )); then
    ydotool key 28:1 28:0
    sleep 1
  fi

  # ready fro char select?
}

# 2. Check if "All" is anywhere in the arguments
if [[ " $@ " =~ " All " ]]; then
  echo "All services selected."
  launch_client 1 
  sleep 1
  launch_client 2
  sleep 1
  launch_client 3 
  exit 0
fi

# 3. Loop through all arguments ($@)
for arg in "$@"; do
    case "$arg" in
        "Linker")
            launch_client 1 
            ;;
        "Bragi")
            launch_client 2
            ;;
        "Prof")
            launch_client 3 
            ;;
        "Alcaster")
#            launch_client 4 
# not implemented
            ;;
        *)
            echo "Skipping unknown option: $arg"
            ;;
    esac
done

