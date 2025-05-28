# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for development environment setup and synchronization. It contains organized configuration files and cross-platform installation scripts for essential development tools.

## Repository Structure

```
├── configs/           # Configuration files
│   ├── .bashrc       # Shell configuration with aliases
│   ├── .gitconfig    # Git user settings
│   └── settings.json # VS Code settings
└── scripts/          # Installation scripts
    ├── install_miniconda.sh  # Python environment (Miniconda3)
    ├── install_poetry.sh     # Python dependency manager
    ├── remove_poetry.sh      # Poetry removal
    ├── install_gh.sh         # GitHub CLI (cross-platform)
    ├── install_uv.sh         # Fast Python package manager
    └── install_tree.sh       # Directory tree utility (cross-platform)
```

## Common Tasks

**Complete environment setup:**
```bash
# Install all development tools
./scripts/install_miniconda.sh
./scripts/install_poetry.sh
./scripts/install_gh.sh
./scripts/install_uv.sh
./scripts/install_tree.sh

# Apply configurations
cp configs/.bashrc ~/
cp configs/.gitconfig ~/
# Copy configs/settings.json to VS Code user settings directory
```

**Individual tool installation:**
```bash
# Install specific tools
./scripts/install_gh.sh     # GitHub CLI
./scripts/install_uv.sh     # Modern Python package manager
./scripts/install_tree.sh   # Directory visualization
```

## Development Notes

- **Cross-platform support**: Scripts detect OS (Linux/macOS) and use appropriate package managers
- **VS Code integration**: Python (Black formatter), TypeScript/JavaScript (Prettier), ESLint on save
- **Python tooling**: Multiple package managers supported (Poetry, uv) with automatic PATH configuration
- **Shell environment**: Standard bash configuration with useful aliases and history settings
- All scripts are executable and include error handling for unsupported systems