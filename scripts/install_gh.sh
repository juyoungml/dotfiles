#!/bin/bash

# ref: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing GitHub CLI for Linux..."
    
    # Add GitHub CLI repository
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing GitHub CLI for macOS..."
    
    # Check if Homebrew is installed
    if command -v brew &> /dev/null; then
        brew install gh
    else
        echo "Homebrew not found. Installing via direct download..."
        # Download and install manually for macOS
        curl -fsSL https://github.com/cli/cli/releases/latest/download/gh_$(uname -m)_macOS.tar.gz | tar -xz
        sudo mv gh_*/bin/gh /usr/local/bin/
        rm -rf gh_*
    fi
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "GitHub CLI installation complete. Run 'gh auth login' to authenticate."