#!/bin/sh
# Idempotent dotfiles installer. It links readable source files and backs up conflicts.
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROFILE=core
DRY_RUN=0
ASSUME_YES=0
INSTALL_PACKAGES=1

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --profile core|dev|agent  core shell, developer tools, or developer + agent config
  --dry-run                 show changes without making them
  --yes                     skip confirmation
  --no-packages             link configuration without installing packages
  --help                    show this help

Examples:
  ./install.sh --dry-run
  ./install.sh --profile dev
  ./install.sh --profile agent --no-packages
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --profile) [ "$#" -ge 2 ] || { echo "Missing profile" >&2; exit 2; }; PROFILE=$2; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --yes) ASSUME_YES=1; shift ;;
    --no-packages) INSTALL_PACKAGES=0; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$PROFILE" in core|dev|agent) ;; *) echo "Unknown profile: $PROFILE" >&2; exit 2 ;; esac

say() { printf '%s\n' "$*"; }
run() {
  if [ "$DRY_RUN" -eq 1 ]; then printf '+ '; printf '%s ' "$@"; printf '\n'; else "$@"; fi
}

backup_path() {
  target=$1
  stamp=$(date +%Y%m%d-%H%M%S)
  backup="${target}.dotfiles-backup-${stamp}"
  say "Backing up $target -> $backup"
  run mv "$target" "$backup"
}

link_file() {
  source=$1
  target=$2
  parent=$(dirname "$target")
  run mkdir -p "$parent"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    say "Already linked: $target"
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then backup_path "$target"; fi
  say "Linking $target -> $source"
  run ln -s "$source" "$target"
}

say "Profile: $PROFILE"
say "Repository: $REPO_DIR"
if [ "$ASSUME_YES" -ne 1 ] && [ "$DRY_RUN" -ne 1 ]; then
  printf 'Continue? [y/N] '
  read -r answer
  case "$answer" in y|Y|yes|YES) ;; *) say "Cancelled"; exit 0 ;; esac
fi

if [ "$INSTALL_PACKAGES" -eq 1 ]; then
  if [ "$DRY_RUN" -eq 1 ]; then say "+ $REPO_DIR/scripts/install-packages.sh $PROFILE";
  else "$REPO_DIR/scripts/install-packages.sh" "$PROFILE"; fi
fi

link_file "$REPO_DIR/config/bashrc" "$HOME/.bashrc"
link_file "$REPO_DIR/config/zshrc" "$HOME/.zshrc"
link_file "$REPO_DIR/config/gitconfig" "$HOME/.gitconfig"
link_file "$REPO_DIR/config/tmux.conf" "$HOME/.tmux.conf"
link_file "$REPO_DIR/shell" "$HOME/.config/dotfiles/shell"
link_file "$REPO_DIR/bin/dots" "$HOME/.local/bin/dots"

run mkdir -p "$HOME/.config/dotfiles"
run mkdir -p "$HOME/.cache/zsh"
if [ ! -e "$HOME/.config/dotfiles/git.local" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then say "+ create ~/.config/dotfiles/git.local from example";
  else cp "$REPO_DIR/examples/git.local" "$HOME/.config/dotfiles/git.local"; fi
fi
if [ ! -e "$HOME/.config/dotfiles/local.sh" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then say "+ create ~/.config/dotfiles/local.sh from example";
  else cp "$REPO_DIR/examples/local.sh" "$HOME/.config/dotfiles/local.sh"; fi
fi

if [ "$PROFILE" = agent ]; then
  link_file "$REPO_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
  link_file "$REPO_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  for skill in "$REPO_DIR"/agents/skills/*; do
    [ -f "$skill/SKILL.md" ] || continue
    name=$(basename "$skill")
    link_file "$skill" "$HOME/.agents/skills/$name"
    link_file "$skill" "$HOME/.claude/skills/$name"
  done
fi

say "Done. Open a new shell, then run: dots doctor"
say "Machine-only settings live in ~/.config/dotfiles/{local.sh,git.local,secrets.env}."
