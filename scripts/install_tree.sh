#!/bin/bash

# Detect OS and install tree command
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing tree for Linux..."
    
    # Detect package manager
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install tree -y
    elif command -v yum &> /dev/null; then
        sudo yum install tree -y
    elif command -v dnf &> /dev/null; then
        sudo dnf install tree -y
    elif command -v pacman &> /dev/null; then
        sudo pacman -S tree --noconfirm
    else
        echo "Unsupported package manager. Please install tree manually."
        exit 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing tree for macOS..."
    
    # Check if Homebrew is installed
    if command -v brew &> /dev/null; then
        brew install tree
    else
        echo "Homebrew not found. Please install Homebrew first or install tree manually."
        exit 1
    fi
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "tree installation complete. Run 'tree --help' to see usage options."