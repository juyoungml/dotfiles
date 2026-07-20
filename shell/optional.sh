# Optional integrations are capability-detected and loaded last.
if [ "$DOTFILES_SHELL" = zsh ]; then
  for syntax_file in \
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    if [ -r "$syntax_file" ]; then . "$syntax_file"; break; fi
  done
fi

if command -v fzf >/dev/null 2>&1; then
  if [ "$DOTFILES_SHELL" = zsh ]; then
    [ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && . /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  elif [ "$DOTFILES_SHELL" = bash ]; then
    [ -r /opt/homebrew/opt/fzf/shell/key-bindings.bash ] && . /opt/homebrew/opt/fzf/shell/key-bindings.bash
  fi
fi

# zoxide learns frequently visited directories; `z name` jumps and `zi` uses fzf.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init "$DOTFILES_SHELL")"
fi

# Homebrew names gdu's executable gdu-go to avoid colliding with GNU du.
if ! command -v gdu >/dev/null 2>&1 && command -v gdu-go >/dev/null 2>&1; then
  alias gdu='gdu-go'
fi

# Delta is an enhancement, never a hard dependency of non-interactive Git commands.
if command -v delta >/dev/null 2>&1; then
  export GIT_PAGER='delta --line-numbers --navigate'
fi
