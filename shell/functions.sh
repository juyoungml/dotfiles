# Create a directory and enter it in one step.
mkcd() { mkdir -p "$1" && cd "$1"; }

# Jump to the root of the current Git checkout.
croot() {
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  cd "$root" || return 1
}

# Start a uv-managed project environment without activating it globally.
ur() { uv run "$@"; }
