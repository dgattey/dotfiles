#! /bin/bash
set -e

# --------------------------
# STATIC FUNCTIONS
# --------------------------

# Creates a name for a staging folder
GET_STAGING_FOLDER() {
    local curr_time
    local hash
    curr_time=$(ruby -e 'puts Time.now.to_f')
    hash=$(echo -n "$curr_time" | shasum | cut -c1-20)
    local dir_name=".${hash}_temp"
    echo "$dir_name"
}

# --------------------------
# CONSTANTS
# --------------------------
REPO=repo
FILESYSTEM=filesystem
FLAG_REPO="$REPO"
FLAG_FS="$FILESYSTEM"
HIDDEN_IN_REPO=hidden
HIDDEN_IN_FS=~
SUBLIME_IN_REPO=sublime
SUBLIME_IN_FS=~/Library/Application\ Support/Sublime\ Text\ 3
XCODE_IN_REPO=xcode/UserData
XCODE_IN_FS=~/Library/Developer/Xcode/UserData
BASH_PROFILE=~/.bash_profile
PROFILE=~/.profile
STAGING=$(GET_STAGING_FOLDER)
TEMP_FILE="$STAGING/tmp"

# --------------------------
# HELPER FUNCTIONS
# --------------------------

# Prints what this script is
print_script_status() {
    local script_name
    script_name=$(basename "$0")
    echo "dotfiles <$script_name>, version $(git describe --tags --always)"
}

# Prints the usage of this script
print_usage() {
    print_script_status
    echo -e "Usage:\t$script_name [direction]"
    echo -e "direction options:"
    echo -e "\t$FLAG_REPO\tcopies from filesystem into this repo"
    echo -e "\t$FLAG_FS\tcopies out to filesystem and installs brew + packages"
}

# Sources the bash profile & other profiles
source_profiles() {
    print_status_message "Sourcing profiles..."
    # shellcheck source=/dev/null
    . "$BASH_PROFILE" &
    print_progress_indicator "Sourcing bash profile "
    print_success_message "Sourced bash profile "
    # shellcheck source=/dev/null
    . "$PROFILE" &
    print_progress_indicator "Sourcing main profile "
    print_success_message "Sourced main profile "
}

# Deletes and recreates the staging folder
create_staging() {
    delete_staging
    mkdir -p "$STAGING"
}

# Deletes $dest, execs rm -rf on the sublime cache, and moves staging to dest
move_staging_to() {
    local dest="$1"
    local user_dest="$STAGING/Packages/User"

    rm -rf "$dest"
    if [ -d "$user_dest" ]; then
        find "$user_dest" -name "*.cache" -exec rm -rf {} +
    fi
    mv "$STAGING" "$dest"
}

# Deletes staging folder
delete_staging() {
    rm -rf "$STAGING"
}

# --------------------------
# COPYING FUNCTIONS
# --------------------------

# Counts files in a directory recursively
count_files_in() {
    local directory="$1"
    find "$directory" -type f | wc -l | xargs echo
}

# Does the bulk of the work for copying files around
do_copy_files() {
    local dest_desc="$1"
    local src="$2"
    local dest="$3"

    # Figure out which place to iterate through & folder to make
    local from
    local to
    if [[ "$dest_desc" = "$FILESYSTEM" ]]; then
        from="$src"
        to="$dest"
    else
        from="$dest"
        to="$STAGING"
    fi

    # Create to folder before anything else
    mkdir -p "$to" &
    print_progress_indicator "Creating destination $to "
    print_success_message "Created destination $to "

    # Iterate over from folder
    for file in "$from"/*; do
        local filename
        filename=$(basename "$file")

        # If DS_STORE, move on
        if [[ "$filename" == ".DS_Store" ]]; then
            continue
        fi

        # Copy file
        if [[ "$dest_desc" = "$FILESYSTEM" ]]; then
            # For a to filesystem copy, just blindly copy the file out recursively
            cp -R "$file" "$dest/" &
        else
            # For a to repo copy, copy src/filename to staging
            cp -R "$src/$filename" "$STAGING/" &
        fi

        print_progress_indicator "Copying $filename $suffix "
        print_success_message "Copied $filename "
    done
}

# Copies all files in a src to dest, printing some statuses along the way
copy_files() {
    local type="$1" # Type of files
    local src="$2" # Source folder
    local dest="$3" # Destination folder
    local dest_desc="$4" # Describes destination ("repo"/"filesystem"/etc)    
    local suffix="to $dest_desc"

    print_status_message "Copying $type files $suffix..."

    local file
    local number_of_files
    
    if [[ "$dest_desc" = "$FILESYSTEM" ]]; then
        do_copy_files "$dest_desc" "$src" "$dest"

        # Show how many we copied
        number_of_files=$(count_files_in "$src")
        print_success_message "Copied all $number_of_files $type files $suffix "
    else
        do_copy_files "$dest_desc" "$src" "$dest"

        # Now that we've copied over all files to staging, let's delete the dest,
        # then move staging to dest after deleting Sublime caches
        move_staging_to "$dest" &
        print_progress_indicator "Moving files to $dest/ "
        number_of_files=$(count_files_in "$dest")
        print_success_message "Copied all $number_of_files $type files $suffix "
    fi
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
# BREW FUNCTIONS
# --------------------------

# Checks for brew, and either installs it or updates it
setup_brew() {
    local package="brew"

    # Check
    command -v "$package" > "$TEMP_FILE" &
    print_progress_indicator "Checking for $package "
    erase_line

    # Do something
    if [[ -z $(head -n 1 "$TEMP_FILE") ]] ; then
        # Install brew
        print_status_message "Installing brew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >"$TEMP_FILE" &
        print_progress_indicator "Downloading and installing brew "
        print_success_message "Successfully installed brew "
        cat "$TEMP_FILE"
    else
        # Update brew
        print_status_message "Updating brew..."
        brew update >"$TEMP_FILE" &
        print_progress_indicator "Downloading brew packages "
        print_success_message "Successfully updated brew "
        cat "$TEMP_FILE"
    fi
}

# Checks for rvm, and either installs it or updates it
setup_rvm() {
    local package="rvm"

    # Prints status
    print_status_message "Checking for rvm..."

    # Check
    command -v "$package" > "$TEMP_FILE" &
    print_progress_indicator "Checking for $package "
    erase_line

    # Do something
    if [[ -z $(head -n 1 "$TEMP_FILE") ]] ; then
        # Install brew
        curl -sSL "https://get.rvm.io" | bash -s "stable" --ruby >"$TEMP_FILE" &
        print_progress_indicator "Downloading and installing rvm "
        print_success_message "Successfully installed rvm "
        cat "$TEMP_FILE"
    else
        # print success
        print_success_message "rvm already installed "
    fi
}

# Installs all the packages!
install_packages() {
    print_status_message "Installing packages..."
    install_package "command -v fuck" "thefuck"
    install_package "command -v pick" "pick"
    install_package "command -v ag" "the_silver_searcher"
    install_package "command -v node" "node"
    install_package "brew ls --versions libyaml" "libyaml"
    install_package "brew ls --versions bash-git-prompt" "bash-git-prompt"
    install_package "command -v go" "go"
    install_package "brew ls --version chisel" "chisel"
    install_package "brew ls --versions git-credential-manager" "git-credential-manager"
}

# Installs a single package by checking a command and installing it if missing
install_package() {
    local check_command="$1"
    local package_name="$2"

    # Note: this is intentionally not escaped so we can execute it
    $check_command > "$TEMP_FILE" &
    print_progress_indicator "Checking for $package_name "

    # Install package if missing (no output)
    if [[ -z $(head -n 1 "$TEMP_FILE") ]]; then
        brew install "$package_name" > "$TEMP_FILE" &
        print_progress_indicator "Installing $package_name "
        print_success_message "$package_name installed "
        cat "$TEMP_FILE"
    else
        print_success_message "$package_name already installed "
    fi
}

# --------------------------
# MAIN
# --------------------------
source print.sh
destination=$1

# Print usage and exit if not one of the supported directions
if [[ "$destination" != "$FILESYSTEM" && "$destination" != "$REPO" ]]; then
    # Print usage and exit
    print_usage
    exit 1
else
    # Prints a little status at the top of the script!
    print_script_status
fi

# Copy all files to destination
copy_files_in_direction "hidden" "$HIDDEN_IN_REPO" "$HIDDEN_IN_FS" "$destination"
copy_files_in_direction "Sublime Package" "$SUBLIME_IN_REPO" "$SUBLIME_IN_FS" "$destination"
copy_files_in_direction "Xcode" "$XCODE_IN_REPO" "$XCODE_IN_FS" "$destination"

# If we're going out to filesystem, let's install the brew packages too
if [[ "$destination" == "$FILESYSTEM" ]]; then
    create_staging
    setup_brew
    install_packages
    setup_rvm
    source_profiles
fi

# Cleanup - delete the staging folder and print a finished message
delete_staging
print_status_message "Finished installing to $destination! "
