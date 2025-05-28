# dotfiles

Setup and sync the development environment with ease.

## Features

### Configuration Files (`configs/`)
- `.bashrc` - Shell configuration with aliases and settings
- `.gitconfig` - Git user configuration  
- `settings.json` - VS Code settings with Python/TypeScript formatting

### Installation Scripts (`scripts/`)
- `install_miniconda.sh` - Miniconda3 installation for Python environment management
- `install_poetry.sh` - Poetry installation for Python dependency management
- `remove_poetry.sh` - Poetry removal script
- `install_gh.sh` - GitHub CLI installation (cross-platform)
- `install_uv.sh` - uv installation (fast Python package manager)
- `install_tree.sh` - tree command installation (cross-platform)

## Quick Setup

```bash
# Install development tools
./scripts/install_miniconda.sh
./scripts/install_poetry.sh
./scripts/install_gh.sh
./scripts/install_uv.sh
./scripts/install_tree.sh

# Copy configurations
cp configs/.bashrc ~/
cp configs/.gitconfig ~/
# Copy configs/settings.json to your VS Code user settings directory
```

## Tasks
- [ ] Tab completion
- [ ] alias
- [ ] .tmux configs
- [ ] .vscode configs
- [ ] NVIDIA GPU configs

## Applications

- [Raycast](https://www.raycast.com/)
