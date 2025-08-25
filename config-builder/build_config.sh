#!/bin/bash
#
# Cisco Configurtion Builder
# Author: Marlin Jaramillo
# Description: Helps build modular configs for Cisco WLCs and Switches.
#

#!/bin/bash

# ===============================
# Cisco Config Builder
# ===============================

SETS_DIR="./sets"
GLOBAL_DIR="./global"
MODULES_DIR="./modules"
OUTPUT_DIR="./output"

mkdir -p "$OUTPUT_DIR"

# Step 1: Pick switch type
echo "Select switch type:"
select SWITCH in "C9800" "3850"; do
    case $SWITCH in
        C9800) GLOBAL_FILE="$GLOBAL_DIR/c9800_global.conf"; break ;;
        3850)  GLOBAL_FILE="$GLOBAL_DIR/3850_global.conf"; break ;;
        *) echo "Invalid option." ;;
    esac
done

# Step 2: Ensure at least one set exists
if [ ! -d "$SETS_DIR" ] || [ -z "$(ls -A "$SETS_DIR")" ]; then
    echo "No configuration sets found in $SETS_DIR."
    echo "Launching Set Manager to create one..."
    ./set_manager.sh
fi

# Step 3: Pick a saved set
echo "Select a configuration set:"
select SET_FILE in "$SETS_DIR"/*; do
    if [ -n "$SET_FILE" ]; then
        break
    else
        echo "Invalid option."
    fi
done

# Step 4: Output file name
read -p "Enter output filename (without extension): " OUT_NAME
OUTPUT_FILE="$OUTPUT_DIR/${OUT_NAME}.conf"

echo "Building configuration into $OUTPUT_FILE ..."

# Start fresh
cat "$GLOBAL_FILE" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Step 5: Process selected modules
while IFS= read -r MODULE; do
    MODULE_FILE="$MODULES_DIR/$MODULE"
    if [ -f "$MODULE_FILE" ]; then
        echo "Adding $MODULE module..."

        if [[ "$MODULE" == "vlans.conf" ]]; then
            # Special VLAN handling
            echo "Do you want to configure VLANs now? (y/n)"
            read VLAN_CHOICE
            if [[ "$VLAN_CHOICE" =~ ^[Yy]$ ]]; then
                while true; do
                    read -p "Enter VLAN ID (or 'done' to finish): " VLAN_ID
                    if [[ "$VLAN_ID" == "done" ]]; then break; fi
                    read -p "Enter VLAN Name: " VLAN_NAME
                    {
                        echo "vlan $VLAN_ID"
                        echo " name $VLAN_NAME"
                        echo "!"
                    } >> "$OUTPUT_FILE"
                done
            else
                cat "$MODULE_FILE" >> "$OUTPUT_FILE"
            fi
        else
            # Standard module, with variable substitution
            while IFS= read -r LINE; do
                eval "echo \"$LINE\"" >> "$OUTPUT_FILE"
            done < "$MODULE_FILE"
        fi

        echo "" >> "$OUTPUT_FILE"
    else
        echo "Skipping missing module: $MODULE"
    fi
done < "$SET_FILE"

echo "Config build complete: $OUTPUT_FILE"