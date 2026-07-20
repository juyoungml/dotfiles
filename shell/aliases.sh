# Small aliases that save real keystrokes; remove any that stop being useful.
alias ll='ls -lah'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'

alias gs='git status --short --branch'
alias gd='git diff'
alias gl='git pull --ff-only'
alias gp='git push'
alias glog='git log --graph --decorate --oneline -20'

alias py='python3'
alias venv='uv venv'
alias activate='source .venv/bin/activate'

# Prefer modern tools when installed while keeping portable fallbacks.
command -v eza >/dev/null 2>&1 && alias ls='eza --group-directories-first'
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
