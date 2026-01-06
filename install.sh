#!/bin/bash
set -e

echo "🚀 Setting up Two Circles Macbook with all required tools"

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Update and install from Brewfile
echo "Updating Homebrew and installing packages..."
brew update
brew bundle install --file="$(dirname "$0")/Brewfile"
brew cleanup

echo "✅ Setup complete! You can see everything installed in the Applications folder"
open /Applications
