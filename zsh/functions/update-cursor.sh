#!/bin/zsh
#
# Cursor AI IDE Installer/Updater
# This script installs or updates Cursor AI IDE on Linux systems
#

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
APPIMAGE_PATH="/opt/cursor/cursor.AppImage"
ICON_PATH="/opt/cursor/cursor.png"
DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"
ICON_URL="https://us1.discourse-cdn.com/flex020/uploads/cursor1/original/2X/a/a4f78589d63edd61a2843306f8e11bad9590f0ca.png"
API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

# Cursor shell function to be added to config files
read -r -d '' CURSOR_FUNCTION << 'EOL'
# Cursor AI IDE launcher function
function cursor() {
    local args=""
    if [ $# -eq 0 ]; then
        args=$(pwd)
    else
        for arg in "$@"; do
            args="$args $arg"
        done
    fi
    local executable=$(find /opt/cursor/cursor.AppImage -type f)
    (nohup $executable --no-sandbox "$args" >/dev/null 2>&1 &)
}
EOL

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

# Ensure required dependencies are installed
ensure_dependencies() {
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing..."
        sudo apt-get update
        sudo apt-get install -y curl
    fi
}

# Check if Cursor is currently running
check_cursor_running() {
    if pgrep -f "cursor.AppImage" > /dev/null; then
        return 0  # Cursor is running
    else
        return 1  # Cursor is not running
    fi
}

# Fetch the latest version information from the Cursor API
fetch_latest_version() {
    local api_response
    api_response=$(curl -s "$API_URL")
    CURSOR_URL=$(echo "$api_response" | grep -o '"downloadUrl":"[^"]*"' | cut -d'"' -f4)
    LATEST_VERSION=$(echo "$api_response" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)

    if [[ -z "$CURSOR_URL" || -z "$LATEST_VERSION" ]]; then
        echo "Error: Failed to fetch version information from API"
        return 1
    fi

    return 0
}

# Get the currently installed version of Cursor
get_current_version() {
    if [[ -f "$APPIMAGE_PATH" ]]; then
        CURRENT_VERSION=$("$APPIMAGE_PATH" --version 2>/dev/null | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
        if [[ -z "$CURRENT_VERSION" ]]; then
            CURRENT_VERSION="unknown"
        fi
    else
        CURRENT_VERSION="not installed"
    fi
}

# Create desktop entry file for application menu integration
create_desktop_entry() {
    echo "Creating desktop entry for Cursor..."
    sudo bash -c "cat > $DESKTOP_ENTRY_PATH" <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
StartupWMClass=Cursor
Categories=Development;
EOL
}

# Download and install the Cursor AppImage
download_and_install() {
    local version="$1"

    # Check if Cursor is running
    if check_cursor_running; then
        echo "Error: Cursor is currently running."
        echo "Please close all instances of Cursor AI IDE and try again."
        return 1
    fi

    # Create installation directory
    sudo mkdir -p "$(dirname "$APPIMAGE_PATH")"

    # Download and set up AppImage
    echo "Downloading Cursor AppImage..."
    sudo curl -L "$CURSOR_URL" -o "$APPIMAGE_PATH"
    sudo chmod +x "$APPIMAGE_PATH"

    # Download and set up icon
    echo "Downloading Cursor icon..."
    sudo curl -L "$ICON_URL" -o "$ICON_PATH"

    # Create desktop entry
    create_desktop_entry

    echo "Cursor AI IDE version $version installation complete."
}

# Determine and get the appropriate shell config file
get_shell_config_file() {
    # Check which shell the user is running
    local shell_path=$(echo "$SHELL")
    local config_file=""

    case "$shell_path" in
        */zsh)
            if [[ -f "$HOME/.zshrc" ]]; then
                config_file="$HOME/.zshrc"
            else
                # Create .zshrc if it doesn't exist
                touch "$HOME/.zshrc"
                config_file="$HOME/.zshrc"
            fi
            ;;
        */bash)
            if [[ -f "$HOME/.bashrc" ]]; then
                config_file="$HOME/.bashrc"
            else
                touch "$HOME/.bashrc"
                config_file="$HOME/.bashrc"
            fi
            ;;
        *)
            # Default to .bashrc for unknown shells
            if [[ -f "$HOME/.bashrc" ]]; then
                config_file="$HOME/.bashrc"
            else
                touch "$HOME/.bashrc"
                config_file="$HOME/.bashrc"
            fi
            ;;
    esac

    echo "$config_file"
}

# Add the cursor function to shell configuration if it doesn't exist
setup_shell_function() {
    local config_file=$(get_shell_config_file)

    echo "Checking for existing cursor function in $config_file..."

    # Check if function already exists in the config file
    if grep -q "function cursor()" "$config_file"; then
        echo "Cursor function already exists in $config_file. No changes needed."
        return 0
    fi

    echo "Adding cursor function to $config_file..."
    echo -e "\n$CURSOR_FUNCTION" >> "$config_file"
    echo "Cursor function added to $config_file."
    echo "Please restart your terminal or run 'source $config_file' to use the cursor command."

    return 0
}

# -----------------------------------------------------------------------------
# Main Functions
# -----------------------------------------------------------------------------

# Fresh installation of Cursor
install_cursor() {
    echo "Installing Cursor AI IDE..."
    ensure_dependencies

    if ! fetch_latest_version; then
        echo "Installation failed. Could not get latest version information."
        return 1
    fi

    echo "Installing Cursor version $LATEST_VERSION"
    download_and_install "$LATEST_VERSION"

    # Setup shell function
    setup_shell_function

    echo "You can find Cursor AI IDE in your application menu or run it by typing 'cursor' in your terminal."
}

# Update an existing Cursor installation
update_cursor() {
    echo "Checking for Cursor updates..."
    ensure_dependencies

    if ! fetch_latest_version; then
        echo "Update check failed. Could not get latest version information."
        return 1
    fi

    get_current_version

    if [[ "$CURRENT_VERSION" == "not installed" ]]; then
        echo "Cursor is not currently installed. Installing now..."
        install_cursor
        return
    fi

    if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
        echo "Cursor is already up to date (version $CURRENT_VERSION)."

        # Make sure shell function is set up even if no update is needed
        setup_shell_function
        return
    fi

    echo "Current version: $CURRENT_VERSION"
    echo "Latest version: $LATEST_VERSION"
    echo "Updating Cursor..."

    # Check if Cursor is running
    if check_cursor_running; then
        echo "Error: Cannot update while Cursor is running."
        echo "Please close all instances of Cursor AI IDE and try again."
        return 1
    fi

    # Download and install the new version
    sudo curl -L "$CURSOR_URL" -o "$APPIMAGE_PATH"
    sudo chmod +x "$APPIMAGE_PATH"

    # Setup shell function
    setup_shell_function

    echo "Cursor has been updated to version $LATEST_VERSION"
}

# Main function to handle installation or update
manage_cursor() {
    if [[ -f "$APPIMAGE_PATH" ]]; then
        echo "Cursor AI IDE is already installed."
        update_cursor
    else
        install_cursor
    fi
}

# -----------------------------------------------------------------------------
# Execute
# -----------------------------------------------------------------------------
manage_cursor
