#!/bin/bash

# Define variables
# ref: https://repo.anaconda.com/miniconda/
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_FILE="Miniconda3-latest-Linux-x86_64.sh"

# Download the Miniconda installer
echo "Downloading Miniconda installer..."
wget $MINICONDA_URL -O $MINICONDA_FILE

# Make the installer executable
echo "Making installer executable..."
chmod +x $MINICONDA_FILE

# Run the installer
echo "Running Miniconda installer..."
./$MINICONDA_FILE -b -p $HOME/miniconda3

# Initialize Miniconda
echo "Initializing Miniconda..."
$HOME/miniconda3/bin/conda init

# Add initialization to .bashrc
echo "Adding Miniconda initialization to ~/.bashrc..."
echo -e "\n# >>> conda initialize >>>\n# !! Contents within this block are managed by 'conda init' !!\n__conda_setup=\"\$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)\"\nif [ \$? -eq 0 ]; then\n    eval \"\$__conda_setup\"\nelse\n    if [ -f \"$HOME/miniconda3/etc/profile.d/conda.sh\" ]; then\n        . \"$HOME/miniconda3/etc/profile.d/conda.sh\"\n    else\n        export PATH=\"$HOME/miniconda3/bin:\$PATH\"\n    fi\nfi\nunset __conda_setup\n# <<< conda initialize <<<\n" >> ~/.bashrc

# Clean up
echo "Cleaning up..."
rm $MINICONDA_FILE

echo "Miniconda installation and setup complete. Please restart your terminal."
