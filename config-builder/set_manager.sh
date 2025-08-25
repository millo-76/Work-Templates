#!/bin/bash

# Set Manager Script
# Manages configuration sets for the Cisco Config Builder

SETS_DIR="./sets"
MODULES_DIR="./modules"

mkdir -p "$SETS_DIR"

# Function to list sets
list_sets() {
    echo "Available Sets:"
    if [ -z "$(ls -A "$SETS_DIR")" ]; then
        echo "  (none found)"
    else
        ls "$SETS_DIR"
    fi
    echo ""
}

# Function to create a new set
create_set() {
    read -p "Enter new set name: " SET_NAME
    SET_FILE="$SETS_DIR/$SET_NAME.set"

    if [ -f "$SET_FILE" ]; then
        echo "A set with that name already exists!"
        return
    fi

    echo "Creating new set: $SET_NAME"
    echo "Select modules to include (enter numbers separated by spaces):"

    # List modules
    MODULES=($(ls "$MODULES_DIR"))
    select MODULE in "${MODULES[@]}" "Done"; do
        if [[ "$MODULE" == "Done" ]]; then
            break
        elif [[ -n "$MODULE" ]]; then
            echo "$MODULE" >> "$SET_FILE"
            echo "Added $MODULE"
        else
            echo "Invalid choice."
        fi
    done

    echo "Set saved: $SET_FILE"
}

# Function to delete a set
delete_set() {
    list_sets
    read -p "Enter set name to delete: " DEL_NAME
    DEL_FILE="$SETS_DIR/$DEL_NAME"
    if [ -f "$DEL_FILE" ]; then
        rm -i "$DEL_FILE"
        echo "Deleted $DEL_FILE"
    else
        echo " Set not found."
    fi
}

# Function to view a set
view_set() {
    list_sets
    read -p "Enter set name to view: " VIEW_NAME
    VIEW_FILE="$SETS_DIR/$VIEW_NAME"
    if [ -f "$VIEW_FILE" ]; then
        echo "Contents of $VIEW_FILE:"
        cat "$VIEW_FILE"
    else
        echo "Set not found."
    fi
}

# ===============================
# Main Menu
# ===============================
while true; do
    echo ""
    echo "===== Set Manager ====="
    echo "1) List Sets"
    echo "2) Create New Set"
    echo "3) View Set"
    echo "4) Delete Set"
    echo "5) Exit"
    echo "======================="
    read -p "Choose an option: " CHOICE

    case $CHOICE in
        1) list_sets ;;
        2) create_set ;;
        3) view_set ;;
        4) delete_set ;;
        5) exit 0 ;;
        *) echo "Invalid option." ;;
    esac
done
