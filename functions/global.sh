# --- Configuration ---
# You can use the same file or a dedicated one for generic variables
VAR_STATE_FILE="/tmp/bash_stored_vars.txt"

# Ensure the file exists so we don't get errors later
touch "$VAR_STATE_FILE"

# --- Functions ---

storeVar() {
    local key="$1"
    local value="$2"
    
    # 1. Clean out any old value for this specific key
    # 2. Append the new key=value pair to the file
    if [[ -f "$VAR_STATE_FILE" ]]; then
        local temp_file
        temp_file=$(mktemp)
        grep -v "^${key}=" "$VAR_STATE_FILE" > "$temp_file"
        mv "$temp_file" "$VAR_STATE_FILE"
    fi
    echo "${key}=${value}" >> "$VAR_STATE_FILE"
}

loadVar() {
    local key="$1"
    local default_value="$2"
    local result=""
    
    if [[ -f "$VAR_STATE_FILE" ]]; then
        # Find the value in the file
        result=$(grep "^${key}=" "$VAR_STATE_FILE" | cut -d'=' -f2-)
    fi

    # If the result is empty, use the provided default value
    if [[ -z "$result" ]]; then
        echo "$default_value"
    else
        echo "$result"
    fi
}