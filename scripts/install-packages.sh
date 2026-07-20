#!/bin/sh
# Install explicit package profiles. No login or secret operation happens here.
set -eu

PROFILE=${1:-core}
REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

case "$PROFILE" in core|dev|agent) ;; *) echo "Unknown profile: $PROFILE" >&2; exit 2 ;; esac

install_uv_if_missing() {
  command -v uv >/dev/null 2>&1 && return 0
  command -v curl >/dev/null 2>&1 || { echo "curl is required to install uv" >&2; exit 1; }
  installer=$(mktemp "${TMPDIR:-/tmp}/uv-install.XXXXXX")
  trap 'rm -f "$installer"' EXIT HUP INT TERM
  curl -LsSf https://astral.sh/uv/install.sh -o "$installer"
  sh "$installer"
  rm -f "$installer"
  trap - EXIT HUP INT TERM
  PATH="$HOME/.local/bin:$PATH"
  export PATH
}

case "$(uname -s)" in
  Darwin)
    command -v brew >/dev/null 2>&1 || {
      echo "Homebrew is required on macOS. Install it from https://brew.sh, then rerun." >&2
      exit 1
    }
    brew bundle --file="$REPO_DIR/packages/Brewfile.core"
    if [ "$PROFILE" = dev ] || [ "$PROFILE" = agent ]; then
      brew bundle --file="$REPO_DIR/packages/Brewfile.dev"
    fi
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y git curl tmux ripgrep fd-find fzf jq tree shellcheck
      if apt-cache show gdu >/dev/null 2>&1; then sudo apt-get install -y gdu; fi
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y git curl tmux ripgrep fd-find fzf jq tree ShellCheck
    else
      echo "Supported Linux package managers: apt-get and dnf." >&2
      exit 1
    fi
    ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

install_uv_if_missing
if [ "$PROFILE" = dev ] || [ "$PROFILE" = agent ]; then
  # uv owns Python CLIs; no global pip, Poetry, or base Conda mutation.
  uv tool install --upgrade 'huggingface_hub[cli]'
  uv tool install --upgrade glances
  uv tool install --upgrade nvitop
fi
