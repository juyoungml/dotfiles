#!/bin/bash

# Claude Code installation script
# ref: https://docs.anthropic.com/en/docs/claude-code/cli-usage

echo "Installing Claude Code..."

# Detect OS and install accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing Claude Code for macOS..."
    
    # Check if Homebrew is installed
    if command -v brew &> /dev/null; then
        echo "Installing via Homebrew..."
        brew install anthropic/claude/claude
    else
        echo "Homebrew not found. Installing via npm..."
        # Install via npm if Homebrew is not available
        if command -v npm &> /dev/null; then
            npm install -g @anthropic-ai/claude-code
        else
            echo "Neither Homebrew nor npm found. Please install one of them first."
            echo "Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            echo "Node.js (includes npm): https://nodejs.org/"
            exit 1
        fi
    fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing Claude Code for Linux..."
    
    # Check if npm is available
    if command -v npm &> /dev/null; then
        echo "Installing via npm..."
        npm install -g @anthropic-ai/claude-code
    else
        echo "npm not found. Installing Node.js first..."
        
        # Detect package manager and install Node.js
        if command -v apt &> /dev/null; then
            # Ubuntu/Debian
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo yum install -y nodejs npm
        elif command -v dnf &> /dev/null; then
            # Fedora
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            sudo dnf install -y nodejs npm
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            sudo pacman -S nodejs npm --noconfirm
        else
            echo "Unsupported package manager. Please install Node.js manually:"
            echo "https://nodejs.org/"
            exit 1
        fi
        
        # Install Claude Code after Node.js installation
        npm install -g @anthropic-ai/claude-code
    fi

else
    echo "Unsupported operating system: $OSTYPE"
    echo "Please visit https://docs.anthropic.com/en/docs/claude-code for manual installation instructions."
    exit 1
fi

# Verify installation
if command -v claude &> /dev/null; then
    echo "✓ Claude Code installed successfully!"
    echo "Version: $(claude --version)"
    echo ""
    echo "Next steps:"
    echo "1. Set up your API key: claude auth login"
    echo "2. Initialize a project: claude init"
    echo "3. Start coding with Claude: claude code"
    echo ""
    echo "For more information, visit: https://docs.anthropic.com/en/docs/claude-code"
else
    echo "✗ Claude Code installation failed. Please check the error messages above."
    exit 1
fi