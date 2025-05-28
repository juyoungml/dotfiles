#!/bin/bash

# ref: https://docs.astral.sh/uv/getting-started/installation/

# Install uv using the official installer
echo "Installing uv (Python package manager)..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH in ~/.bashrc
echo "Adding uv to PATH in ~/.bashrc..."
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Inform user to reload ~/.bashrc
echo "Please run 'source ~/.bashrc' to update your PATH."

echo "uv installation complete. Run 'uv --help' to get started."