# dotfiles

Setup and sync the development environment with ease.

## Features

### Configuration Files (`configs/`)
- `.bashrc` - Enhanced shell configuration with git branch display, tab completion, and useful aliases
- `.gitconfig` - Git user configuration  
- `.tmux.conf` - Tmux configuration with mouse support and scrolling
- `settings.json` - Enhanced VS Code settings with editor improvements and terminal configuration
- `extensions.json` - Recommended VS Code extensions for development

### Installation Scripts (`scripts/`)
- `install_miniconda.sh` - Miniconda3 installation for Python environment management
- `install_poetry.sh` - Poetry installation for Python dependency management
- `remove_poetry.sh` - Poetry removal script
- `install_gh.sh` - GitHub CLI installation (cross-platform)
- `install_uv.sh` - uv installation (fast Python package manager)
- `install_tree.sh` - tree command installation (cross-platform)
- `install_nvidia.sh` - NVIDIA GPU drivers, CUDA, and Docker support (Linux)

## Quick Setup

### Using Makefile (Recommended)
```bash
# Install everything
make install-all

# Or install specific components
make install-tools      # Install all development tools
make install-configs    # Copy configuration files
make install-python     # Install Python tools only
make install-dev        # Install development tools only
make install-nvidia     # Install NVIDIA support (Linux)
make install-vscode     # Install VS Code extensions

# See all options
make help
```

### Manual Installation
```bash
# Install development tools
./scripts/install_miniconda.sh
./scripts/install_poetry.sh
./scripts/install_gh.sh
./scripts/install_uv.sh
./scripts/install_tree.sh
./scripts/install_nvidia.sh  # Linux only

# Copy configurations
cp configs/.bashrc ~/
cp configs/.gitconfig ~/
cp configs/.tmux.conf ~/
# Copy configs/settings.json to your VS Code user settings directory
```

## Tasks
- [x] support tab completion
- [x] set useful terminal theme
- [x] alias (useful aliases)
- [x] .tmux configs (support scrolling)
- [x] .vscode configs
- [x] NVIDIA GPU configs
- [x] Create Makefile so that the installation scripts are easier to use
- [ ] Install Claude Code
- [ ] Install Cursor (Mac only)

## Applications

- [Raycast](https://www.raycast.com/)
