#! /bin/bash
set -e

# Echo an error message before exiting
err_report() {
    echo "$(tput setaf 1)error on line $1$(tput sgr0)"
}
trap 'err_report $LINENO' ERR

# --------------------------
# CONSTANTS
# --------------------------
ERASE="\\r\\033[K"

# --------------------------
# PRINT FUNCTIONS
# --------------------------

erase_line() {
    echo -en "$ERASE"
}

# Echos a simple status message in blue
print_status_message() {
    local message=$1

    echo -e "$(tput setaf 6)$message$(tput sgr0)"
}

# Prints a success message with a green checkmark
print_success_message() {
    local message=$1

    erase_line
    echo -en "$message"
    echo -e "$(tput setaf 2)√$(tput sgr0)"
}

# Prints a "working" message
print_working_message() {
    local spin='-\|/'

    local overall_spin_iteration=$1
    local message=$2
    local verification_message=$3

    local spin_iteration=$((overall_spin_iteration%4))

    # Special case the first few iterations to show a verification message as needed
    if [ "$overall_spin_iteration" -lt 6 ] && [ "$verification_message" != "" ]; then
        message="$verification_message"
    fi

    erase_line
    print_information_message "$message"
    printf "%s" "${spin:$spin_iteration:1}"
}

# Prints an informative string in yellow with given message content
print_information_message() {
    local message=$1
    echo -en "$(tput setaf 3)$message$(tput sgr0)"
}

# Prints an error message with a skull and crossbones to show that
# something was impossible, with an optional progress message
print_error_message() {
    local message=$1
    local progress_message=$2

    erase_line
    echo -en "$(tput setaf 1)"
    echo -en "$message  "
    echo -en $'\xE2\x98\xA0' # Skull and crossbones
    print_information_message "$progress_message"
    echo ""
}

# Prints a spinning progress indicator until the last command before this
# is finished. It uses the message passed in to print a status message
print_progress_indicator() {
    local message=$1
    local verification_message=$2

    local pid=$!

    # Prints a message that moves so we show progress
    local spin_iteration=0
    while kill -0 $pid 2>/dev/null
    do
      spin_iteration=$((spin_iteration+1))
      print_working_message "$spin_iteration" "$message" "$verification_message"
      sleep .15
    done
}

# --------------------------
# MAIN
# --------------------------
shopt -s dotglob # Enables seeing hidden files when iterating over a directory
