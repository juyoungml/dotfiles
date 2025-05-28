# Dotfiles Makefile
# Simplified installation and configuration management

.PHONY: help install install-tools install-configs install-all clean

# Default target
help:
	@echo "Dotfiles Management"
	@echo "=================="
	@echo ""
	@echo "Available targets:"
	@echo "  help           - Show this help message"
	@echo "  install-tools  - Install all development tools"
	@echo "  install-configs- Copy configuration files to home directory"
	@echo "  install-all    - Install tools and apply configs"
	@echo "  install-python - Install Python tools (miniconda, poetry, uv)"
	@echo "  install-dev    - Install development tools (gh, tree)"
	@echo "  install-nvidia - Install NVIDIA GPU support (Linux only)"
	@echo "  install-vscode - Install VS Code extensions"
	@echo "  clean          - Remove temporary files"
	@echo ""
	@echo "Individual tool installation:"
	@echo "  miniconda      - Install Miniconda"
	@echo "  poetry         - Install Poetry"
	@echo "  uv             - Install uv"
	@echo "  gh             - Install GitHub CLI"
	@echo "  tree           - Install tree command"
	@echo "  nvidia         - Install NVIDIA drivers and CUDA"

# Install all development tools
install-tools: miniconda poetry uv gh tree
	@echo "✓ All development tools installed"

# Install Python-related tools
install-python: miniconda poetry uv
	@echo "✓ Python development tools installed"

# Install general development tools
install-dev: gh tree
	@echo "✓ Development tools installed"

# Copy configuration files
install-configs:
	@echo "Installing configuration files..."
	@cp configs/.bashrc ~/
	@cp configs/.gitconfig ~/
	@cp configs/.tmux.conf ~/
	@echo "✓ Configuration files copied to home directory"
	@echo "Note: Copy configs/settings.json manually to your VS Code settings directory"
	@echo "Note: Copy configs/extensions.json to your VS Code extensions directory"

# Install everything
install-all: install-tools install-configs
	@echo "✓ Complete installation finished"
	@echo "Please restart your terminal or run 'source ~/.bashrc'"

# Individual tool installations
miniconda:
	@echo "Installing Miniconda..."
	@./scripts/install_miniconda.sh

poetry:
	@echo "Installing Poetry..."
	@./scripts/install_poetry.sh

uv:
	@echo "Installing uv..."
	@./scripts/install_uv.sh

gh:
	@echo "Installing GitHub CLI..."
	@./scripts/install_gh.sh

tree:
	@echo "Installing tree..."
	@./scripts/install_tree.sh

nvidia:
	@echo "Installing NVIDIA support..."
	@./scripts/install_nvidia.sh

# VS Code extension installation
install-vscode:
	@echo "Installing VS Code extensions..."
	@if command -v code >/dev/null 2>&1; then \
		echo "Installing recommended extensions..."; \
		code --install-extension ms-python.python; \
		code --install-extension ms-python.black-formatter; \
		code --install-extension esbenp.prettier-vscode; \
		code --install-extension eamodio.gitlens; \
		code --install-extension github.copilot; \
		code --install-extension ms-vscode.vscode-icons; \
		echo "✓ VS Code extensions installed"; \
	else \
		echo "VS Code not found. Please install VS Code first."; \
	fi

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@echo "✓ Cleanup complete"

# Display system information
info:
	@echo "System Information"
	@echo "=================="
	@echo "OS: $$(uname -s)"
	@echo "Architecture: $$(uname -m)"
	@echo "Shell: $$SHELL"
	@echo "Python: $$(python3 --version 2>/dev/null || echo 'Not installed')"
	@echo "Git: $$(git --version 2>/dev/null || echo 'Not installed')"
	@echo "VS Code: $$(code --version 2>/dev/null | head -1 || echo 'Not installed')"