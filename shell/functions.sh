# Create a directory and enter it in one step.
mkcd() { mkdir -p "$1" && cd "$1"; }

# Jump to the root of the current Git checkout.
croot() {
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  cd "$root" || return 1
}

# Start a uv-managed project environment without activating it globally.
ur() { uv run "$@"; }

# Jump inside the personal VAST workspace without spelling the full mount.
jcd() {
  root=${TRILLION_JUYOUNG_ROOT:-/mnt/vast/trillion/juyoung}
  if [ "$#" -eq 0 ]; then
    cd "$root" || return 1
  else
    cd "$root/$1" || return 1
  fi
}

# Show my Slurm queue.
sq() {
  command -v squeue >/dev/null 2>&1 || { echo "squeue is not installed" >&2; return 127; }
  squeue --me "$@"
}

# Show one Slurm job using the reliable scheduler path.
sj() {
  [ "$#" -eq 1 ] || { echo "Usage: sj JOB_ID" >&2; return 2; }
  command -v squeue >/dev/null 2>&1 || { echo "squeue is not installed" >&2; return 127; }
  squeue -j "$1"
}

# Print Slurm's full record for a job.
sjob() {
  [ "$#" -eq 1 ] || { echo "Usage: sjob JOB_ID" >&2; return 2; }
  command -v scontrol >/dev/null 2>&1 || { echo "scontrol is not installed" >&2; return 127; }
  scontrol show job "$1"
}

# Tail the common logs/%x/%j/main.out layout from the current checkout.
slog() {
  [ "$#" -ge 1 ] || { echo "Usage: slog JOB_ID [LINES]" >&2; return 2; }
  job_id=$1
  lines=${2:-80}
  log_file=$(find logs -path "*/$job_id/main.out" -type f -print -quit 2>/dev/null)
  [ -n "$log_file" ] || { echo "No logs/*/$job_id/main.out found under $(pwd)" >&2; return 1; }
  tail -n "$lines" "$log_file"
}

# Disk usage for mounted filesystems. Prefer gdu when installed and stay on one filesystem.
vdu() {
  if command -v gdu >/dev/null 2>&1; then
    gdu -x "$@"
  elif command -v gdu-go >/dev/null 2>&1; then
    gdu-go -x "$@"
  else
    du -sh "$@"
  fi
}
