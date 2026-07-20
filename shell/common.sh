# Shared environment. Keep startup work here synchronous, deterministic, and cheap.

path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH" ;; esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/.cargo/bin"
[ "$(uname -s)" = Darwin ] && path_prepend /opt/homebrew/bin
export PATH
unset -f path_prepend 2>/dev/null || true

export PAGER=${PAGER:-less}
export LESS=${LESS:--FRX}
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-$EDITOR}
export PYTHONDONTWRITEBYTECODE=1
export UV_LINK_MODE=${UV_LINK_MODE:-copy}

# Public config never contains secrets. This local file is for paths and preferences only.
[ -r "$HOME/.config/dotfiles/local.sh" ] && . "$HOME/.config/dotfiles/local.sh"
