#!/bin/sh
# Stable public entrypoint: clone/update the repository, then hand off to install.sh.
set -eu

DOTFILES_REPO=${DOTFILES_REPO:-https://github.com/juyoungml/dotfiles.git}
DOTFILES_HOME=${DOTFILES_HOME:-"$HOME/.dotfiles"}
DOTFILES_REF=${DOTFILES_REF:-main}

command -v git >/dev/null 2>&1 || {
  echo "git is required. Install it with Xcode Command Line Tools or your OS package manager." >&2
  exit 1
}

if [ -e "$DOTFILES_HOME" ] && [ ! -d "$DOTFILES_HOME/.git" ]; then
  echo "$DOTFILES_HOME exists but is not a Git checkout; refusing to overwrite it." >&2
  exit 1
fi

if [ -d "$DOTFILES_HOME/.git" ]; then
  git -C "$DOTFILES_HOME" fetch --quiet origin "$DOTFILES_REF"
  git -C "$DOTFILES_HOME" checkout --quiet "$DOTFILES_REF"
  git -C "$DOTFILES_HOME" pull --ff-only --quiet
else
  git clone --filter=blob:none --branch "$DOTFILES_REF" "$DOTFILES_REPO" "$DOTFILES_HOME"
fi

exec "$DOTFILES_HOME/install.sh" "$@"
