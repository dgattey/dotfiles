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
HIDDEN_SOURCE=hidden
HIDDEN_DESTINATION=~
SUBLIME_SOURCE=sublime
SUBLIME_DESTINATION=~/Library/Application\ Support/Sublime\ Text\ 3
XCODE_SOURCE=xcode
XCODE_DESTINATION=~/Library/Developer/Xcode

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

# Counts files in a directory recursively
count_files_in() {
    local directory=$1
    find $directory -type f | wc -l | xargs echo
}

# Copies all files in a src to dest, printing some statuses along the way
copy_files() {
    local type=$1
    local src=$2
    local dest=$3
    local number_of_files=$(count_files_in "$src")

    print_status_message "Copying $type files..."

    # Create dest before anything else
    mkdir -p "$dest" &
    print_progress_indicator "Creating $dest "
    print_success_message "Created $dest "

    # Loop through all files including hidden ones
    local file
    for file in "$src"/*; do
        # If DS_STORE, move on
        if [[ "$file" = "$src/.DS_Store" ]]; then
            continue
        fi

        # If directory, make the corresponding folder in destination
        if [ -d ${file} ]; then
            mkdir -p "$dest/$file" &
            print_progress_indicator "Making directory $dest/$file "
        fi

        # Copy the file and show success when done
        cp -R "$file" "$dest/" &
        print_progress_indicator "Copying $file "
        print_success_message "Copied $file "
    done

    # Show how many we copied
    print_success_message "Copied all $number_of_files $type files "
}

# --------------------------
# MAIN
# --------------------------
shopt -s dotglob # Enables seeing hidden files when iterating over a directory
copy_files "hidden" "$HIDDEN_SOURCE" "$HIDDEN_DESTINATION"
copy_files "Sublime Package" "$SUBLIME_SOURCE" "$SUBLIME_DESTINATION"
copy_files "Xcode" "$XCODE_SOURCE" "$XCODE_DESTINATION"

exit 1

echo "Installing brew" &&
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
brew install thefuck &&
brew install pick &&
brew install the_silver_searcher &&
brew install node &&
brew install libyaml &&

echo "Done installing! Good to goooo. All you need to do is source the bash profile"
