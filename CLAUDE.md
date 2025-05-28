# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for development environment setup and synchronization. It contains organized configuration files and cross-platform installation scripts for essential development tools.

## Repository Structure

```
├── configs/           # Configuration files
│   ├── .bashrc       # Enhanced shell with git branch, tab completion, aliases
│   ├── .gitconfig    # Git user settings
│   ├── .tmux.conf    # Tmux with mouse support and scrolling
│   ├── settings.json # Enhanced VS Code settings
│   └── extensions.json # VS Code extension recommendations
├── scripts/          # Installation scripts
│   ├── install_miniconda.sh  # Python environment (Miniconda3)
│   ├── install_poetry.sh     # Python dependency manager
│   ├── remove_poetry.sh      # Poetry removal
│   ├── install_gh.sh         # GitHub CLI (cross-platform)
│   ├── install_uv.sh         # Fast Python package manager
│   ├── install_tree.sh       # Directory tree utility (cross-platform)
│   ├── install_claude_code.sh # Claude Code CLI (cross-platform)
│   └── install_nvidia.sh     # NVIDIA GPU support (Linux)
└── Makefile          # Simplified installation management
```

## Common Tasks

**Complete environment setup (recommended):**
```bash
make install-all
```

**Component-specific installation:**
```bash
make install-tools      # All development tools
make install-configs    # Configuration files only
make install-python     # Python tools (miniconda, poetry, uv)
make install-dev        # Development tools (gh, tree)
make install-nvidia     # NVIDIA GPU support (Linux)
make install-vscode     # VS Code extensions
```

**Manual installation:**
```bash
# Install all development tools
./scripts/install_miniconda.sh
./scripts/install_poetry.sh
./scripts/install_gh.sh
./scripts/install_uv.sh
./scripts/install_tree.sh
./scripts/install_claude_code.sh
./scripts/install_nvidia.sh  # Linux only

# Apply configurations
cp configs/.bashrc ~/
cp configs/.gitconfig ~/
cp configs/.tmux.conf ~/
# Copy configs/settings.json and extensions.json to VS Code directories
```

**Individual tool installation:**
```bash
make miniconda          # Python environment
make poetry             # Python dependency manager
make gh                 # GitHub CLI
make claude-code        # Claude Code CLI
make nvidia             # NVIDIA support
```

## Development Notes

- **Makefile automation**: Use `make help` to see all available commands for easy installation
- **Cross-platform support**: Scripts detect OS (Linux/macOS) and use appropriate package managers  
- **Enhanced shell**: `.bashrc` includes git branch display, tab completion, and comprehensive aliases
- **Tmux configuration**: Mouse support enabled with scrolling and improved navigation
- **VS Code integration**: Enhanced settings with editor improvements, extension recommendations
- **Python tooling**: Multiple package managers (Poetry, uv) with automatic PATH configuration
- **NVIDIA support**: Comprehensive GPU setup including drivers, CUDA, and Docker integration
- **Safety features**: Interactive prompts for destructive operations (rm, cp, mv)
- All scripts include error handling and cross-platform compatibility checks