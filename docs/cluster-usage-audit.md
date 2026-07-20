# Cluster Usage Audit

This audit distills repeatable patterns from local Claude/Codex state and
repository instruction files under `/mnt/vast/trillion/juyoung`. It intentionally
does not mirror raw sessions, credentials, caches, memories, or private project
history.

## Promoted Patterns

- Keep Python workflows `uv`-first: `uv sync`, `uv run`, `uv add`, and explicit
  dependency groups.
- Treat `/mnt/vast/trillion/juyoung` as the canonical compute-node path. Avoid
  relying on home-directory symlinks when paths will be passed to Slurm jobs.
- Use Slurm for cluster compute and service jobs. `squeue` and `scontrol show job`
  are the reliable status path; `sacct` may be unavailable or stale.
- Prefer self-documenting Slurm logs such as `logs/%x/%j/main.out`, then tail the
  job log after it leaves the queue.
- Avoid repeated deep `find` or `du` loops on VAST/NFS-backed trees. Prefer one
  deliberate scan, logs, process counters, or `gdu -x` for filesystem-local usage.
- Keep generated logs, checkpoints, caches, large sidecars, and raw data out of
  Git. Stage explicit paths in dirty worktrees.
- Maintain project-specific job-name prefixes in project-local instructions
  rather than global dotfiles.

## Dotfiles Changes

- Shell helpers now include `jc`, `jcyan`, and `jcd` for the personal VAST
  workspace, parameterized by `TRILLION_JUYOUNG_ROOT`.
- Slurm helpers now include `sq`, `sj`, `sjob`, and `slog` for common queue,
  record, and `logs/%x/%j/main.out` workflows.
- `vdu` prefers `gdu -x` when present and falls back to `du -sh`.
- Agent guidance lives in `agents/skills/cluster/SKILL.md` so the global
  instruction file stays small.

## Not Promoted

- Local model server probes and endpoint assumptions. Those are project/runtime
  specific, not a universal dotfiles pattern.
- Raw `.claude` and `.codex` files: credentials, auth state, sessions, shell
  snapshots, histories, caches, MCP state, and inferred memories.
- Cluster node exclusions or job-name prefixes as shell defaults. They vary by
  project and should remain in repository-local `AGENTS.md`/`CLAUDE.md` files.
