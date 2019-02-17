#! /bin/bash
set -e

# --------------------------
# CONSTANTS
# --------------------------
REPO=repo
FILESYSTEM=filesystem
FLAG_REPO="--to-repo"
FLAG_FS="--to-fs"
HIDDEN_IN_REPO=hidden
HIDDEN_IN_FS=~
SUBLIME_IN_REPO=sublime
SUBLIME_IN_FS=~/Library/Application\ Support/Sublime\ Text\ 3
XCODE_IN_REPO=xcode
XCODE_IN_FS=~/Library/Developer/Xcode

# --------------------------
# HELPER FUNCTIONS
# --------------------------

# Counts files in a directory recursively
count_files_in() {
    local directory=$1
    find $directory -type f | wc -l | xargs echo
}

# Copies all files in a src to dest, printing some statuses along the way
copy_files() {
    local type="$1" # Type of files
    local src="$2" # Source folder
    local dest="$3" # Destination folder
    local dest_desc="$4" # Describes destination ("repo"/"filesystem"/etc)
    
    local number_of_files=$(count_files_in "$src")
    local suffix="to $dest_desc"

    print_status_message "Copying $type files $suffix..."

    # Create dest before anything else
    mkdir -p "$dest" &
    print_progress_indicator "Creating $dest "
    print_success_message "Created $dest "

    # Loop through all files including hidden ones
    local file
    for file in "$src"/*; do
        # If DS_STORE, move on
        if [[ "$filename" = ".DS_Store" ]]; then
            continue
        fi

        local filename
        filename=$(basename "$file")

        # Copy the file and show success when done
        cp -R "$file" "$dest/" &
        print_progress_indicator "Copying $filename to $dest "
        print_success_message "Copied $filename "
    done

    # Show how many we copied
    print_success_message "Copied all $number_of_files $type files $suffix "
}

# Copies files in a certain direction (either "repo" or "filesystem")
copy_files_in_direction() {
    local type="$1"
    local repo_src="$2"
    local fs_src="$3"
    local dest_direction="$4"

    # Copy based on the destination direction
    if [[ "$dest_direction" = "$REPO" ]]; then
        copy_files "$type" "$fs_src" "$repo_src" "$dest_direction"
    elif [[ "$dest_direction" = "$FILESYSTEM" ]]; then
        copy_files "$type" "$repo_src" "$fs_src" "$dest_direction"
    fi
}

# --------------------------
# MAIN
# --------------------------
source print.sh
flag=$1
direction=""

# Parse the flags
if [[ "$flag" = "$FLAG_FS" ]]; then
    # Copy files from repo to filesystem
    direction="$FILESYSTEM"
elif [[ "$flag" = "$FLAG_REPO" ]]; then
    # Copy files from filesystem to repo
    direction="$REPO"
else
    # Print usage and exit
    echo "dotfiles <install.sh>, version $(git describe --tags --always)"
    echo -e "Usage:\tinstall.sh [direction]"
    echo -e "direction options:"
    echo -e "\t$FLAG_REPO\t(copies from filesystem into this repo)"
    echo -e "\t$FLAG_FS\t\t(copies from repo out to filesystem)"
    exit 1
fi

# Copy all files
copy_files_in_direction "hidden" "$HIDDEN_IN_REPO" "$HIDDEN_IN_FS" "$direction"
copy_files_in_direction "Sublime Packages" "$SUBLIME_IN_REPO" "$SUBLIME_IN_FS" "$direction"
copy_files_in_direction "Xcode" "$XCODE_IN_REPO" "$XCODE_IN_FS" "$direction"

exit 1

echo "Installing brew" &&
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
brew install thefuck &&
brew install pick &&
brew install the_silver_searcher &&
brew install node &&
brew install libyaml &&

echo "Done installing! Good to goooo. All you need to do is source the bash profile"
