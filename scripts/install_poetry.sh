#!/bin/bash

# ref: https://python-poetry.org/docs/#installing-with-the-official-installer

# Install Poetry
echo "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH in ~/.bashrc
echo "Adding Poetry to PATH in ~/.bashrc..."
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Inform user to reload ~/.bashrc
echo "Please run 'source ~/.bashrc' to update your PATH."

echo "Poetry installation complete."
