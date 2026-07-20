#!/bin/sh
# Local/CI verification: syntax, install behavior, and obvious public-repo leaks.
set -eu
REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

sh -n "$REPO_DIR/install.sh" "$REPO_DIR/bootstrap.sh" "$REPO_DIR/bin/dots" \
  "$REPO_DIR/scripts/install-packages.sh" "$REPO_DIR/scripts/check.sh"
bash -n "$REPO_DIR/config/bashrc" "$REPO_DIR/shell/"*.sh
command -v zsh >/dev/null 2>&1 && zsh -n "$REPO_DIR/config/zshrc" "$REPO_DIR/shell/"*.sh

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -x "$REPO_DIR/install.sh" "$REPO_DIR/bootstrap.sh" "$REPO_DIR/bin/dots" \
    "$REPO_DIR/scripts/install-packages.sh" "$REPO_DIR/scripts/check.sh"
fi

test_home=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-check.XXXXXX")
trap 'rm -rf "$test_home"' EXIT HUP INT TERM
HOME="$test_home" "$REPO_DIR/install.sh" --profile core --no-packages --yes >/dev/null
HOME="$test_home" "$REPO_DIR/install.sh" --profile core --no-packages --yes >/dev/null
[ -L "$test_home/.bashrc" ] && [ -L "$test_home/.config/dotfiles/shell" ]
HOME="$test_home" bash --noprofile --rcfile "$test_home/.bashrc" -ic \
  'type mkcd >/dev/null; alias gs >/dev/null; test "$DOTFILES_SHELL" = bash' 2>/dev/null
if command -v zsh >/dev/null 2>&1; then
  HOME="$test_home" ZDOTDIR="$test_home" zsh -d -i -c \
    'type mkcd >/dev/null; alias gs >/dev/null; test "$DOTFILES_SHELL" = zsh' 2>/dev/null
fi
HOME="$test_home" "$test_home/.local/bin/dots" explain auth >/dev/null
HOME="$test_home" "$test_home/.local/bin/dots" quiz >/dev/null

quiz_file="$REPO_DIR/docs/quiz.md"
question_count=$(grep -c '^Q: ' "$quiz_file")
answer_count=$(grep -c '^Answer: [ABCD]$' "$quiz_file")
option_a_count=$(grep -c '^A) ' "$quiz_file")
option_d_count=$(grep -c '^D) ' "$quiz_file")
[ "$question_count" -gt 0 ]
[ "$question_count" -eq "$answer_count" ]
[ "$question_count" -eq "$option_a_count" ]
[ "$question_count" -eq "$option_d_count" ]

if git -C "$REPO_DIR" grep -En '(ghp_[A-Za-z0-9]{20,}|hf_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9_-]{20,}|BEGIN (RSA|OPENSSH) PRIVATE KEY)' -- . ':!docs/report.html'; then
  echo "Possible secret material found in tracked files." >&2
  exit 1
fi

echo "All checks passed."
