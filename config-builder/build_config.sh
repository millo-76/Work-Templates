#!/bin/bash
#
# Cisco Configurtion Builder
# Author: Marlin Jaramillo
# Description: Helps build modular configs for Cisco WLCs and Switches.
#

# -------------------------------
# Paths
# -------------------------------
GLOBAL_DIR="./global"
MODULE_DIR="./modules"
SET_DIR="./sets"
OUTPUT_DIR="./output"

# Ensure directories exist
mkdir -p "$GLOBAL_DIR" "$MODULE_DIR" "$SET_DIR" "$OUTPUT_DIR"

# -------------------------------
# Step 1: Pick device type
# -------------------------------
echo "Select device type:"
select DEVTYPE in "C9800-WLC" "Catalyst-3850" "Quit"; do
  case $DEVTYPE in
    "C9800-WLC")
      GLOBAL_FILE="$GLOBAL_DIR/c9800_global.conf"
      break
      ;;
    "Catalyst-3850")
      GLOBAL_FILE="$GLOBAL_DIR/3850_global.conf"
      break
      ;;
    "Quit")
      exit 0
      ;;
    *)
      echo "Invalid option."
      ;;
  esac
done

# -------------------------------
# Step 2: Manage module sets
# -------------------------------
echo "Do you want to manage your saved module sets? (y/n)"
read MANAGE
if [[ "$MANAGE" == "y" ]]; then
  echo "Module Set Manager"
  select ACTION in "List Sets" "Delete Set" "Edit Set" "Back"; do
    case $ACTION in
      "List Sets")
        echo "Available sets:"
        ls "$SET_DIR"
        ;;
      "Delete Set")
        echo "Select a set to delete:"
        select DELSET in $(ls $SET_DIR); do
          if [[ -f "$SET_DIR/$DELSET" ]]; then
            rm "$SET_DIR/$DELSET"
            echo "🗑️ Deleted $DELSET"
            break
          fi
        done
        ;;
      "Edit Set")
        echo "Select a set to edit:"
        select EDITSET in $(ls $SET_DIR); do
          if [[ -f "$SET_DIR/$EDITSET" ]]; then
            nano "$SET_DIR/$EDITSET"
            echo "✏️ Edited $EDITSET"
            break
          fi
        done
        ;;
      "Back")
        break
        ;;
    esac
  done
fi

# -------------------------------
# Step 3: Select or create module set
# -------------------------------
echo "Do you want to use an existing module set? (y/n)"
read USESET
if [[ "$USESET" == "y" ]]; then
  echo "Select a set:"
  select SETFILE in $(ls $SET_DIR); do
    MODULES=$(cat "$SET_DIR/$SETFILE")
    echo "Using set: $SETFILE"
    break
  done
else
  echo "Select modules to include (space-separated numbers):"
  select MOD in $(ls $MODULE_DIR); do
    echo "You selected: $MOD"
  done
  read -p "Enter modules (space-separated): " MODULES
  echo "Save this selection as a new set? (y/n)"
  read SAVESET
  if [[ "$SAVESET" == "y" ]]; then
    read -p "Enter set name: " NEWSET
    echo "$MODULES" > "$SET_DIR/$NEWSET.set"
    echo "💾 Saved set as $NEWSET.set"
  fi
fi

# -------------------------------
# Step 4: Collect variables
# -------------------------------
echo "Enter hostname: "
read HOSTNAME
echo "Enter domain name: "
read DOMAIN
echo "Enter management VLAN ID: "
read VLANID

# -------------------------------
# Step 5: Assemble config
# -------------------------------
OUTFILE="$OUTPUT_DIR/${HOSTNAME}_config.txt"
echo "Building config -> $OUTFILE"

# Start with global config
cp "$GLOBAL_FILE" "$OUTFILE"

# Add each module
for M in $MODULES; do
  if [[ -f "$MODULE_DIR/$M" ]]; then
    cat "$MODULE_DIR/$M" >> "$OUTFILE"
  fi
done

# Replace variables in config
sed -i "s/\$WLCName\$/$HOSTNAME/g" "$OUTFILE"
sed -i "s/\$DomainName\$/$DOMAIN/g" "$OUTFILE"
sed -i "s/\$MgmtVLAN\$/$VLANID/g" "$OUTFILE"

echo "✅ Config build complete: $OUTFILE"