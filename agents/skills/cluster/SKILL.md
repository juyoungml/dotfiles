# Cluster Workflow

Use this skill when working on the Trillion cluster, especially under
`/mnt/vast/trillion/juyoung`, with Slurm jobs, VAST-backed data, or Cyan-family
repositories.

## Defaults

- Use `uv` for Python: `uv sync`, `uv run`, `uv add`, and dependency groups.
  Do not switch to Poetry, base Conda initialization, global `pip`, or bare
  `python` for project commands unless the repository explicitly requires it.
- Prefer canonical VAST paths such as `/mnt/vast/trillion/juyoung/...` in job
  scripts and commands that will run on compute nodes.
- Read the nearest `AGENTS.md` or `CLAUDE.md` before acting. Project-local
  branch policy, validation commands, node exclusions, and job-name prefixes
  override this general skill.

## Slurm

- Submit compute and service work through the repository's Slurm entrypoints
  when they exist.
- After `sbatch`, track the job with `squeue -j <job_id>`. Use
  `scontrol show job <job_id>` for full scheduler state.
- Treat `sacct` as optional; Slurm accounting can be unavailable without meaning
  the job failed.
- When the job leaves the queue, inspect the expected log and output artifact.
  Common Cyan-style logs are under `logs/%x/%j/main.out`.
- Preserve project-specific job naming conventions in that project's own
  instructions and scripts.

## VAST And Large Data

- Avoid repeated deep metadata walks (`find`, `du`, broad recursive `rg`) on
  shared VAST/NFS trees during active writes.
- Prefer a single deliberate inventory, writer logs, process I/O counters, or
  `gdu -x` for filesystem-local disk inspection.
- Never dedupe or rewrite large datasets in place. Choose an explicit output
  path, validate structure and loader behavior, then treat deletion as a
  separate gated step.
- Keep heavy artifacts out of Git: checkpoints, logs, raw datasets, hash
  sidecars, caches, and generated reports unless the repository explicitly
  tracks a small summary artifact.
