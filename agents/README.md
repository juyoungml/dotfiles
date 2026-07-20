# Agent-native configuration

This directory is the reviewed, public control plane for agent behavior. The `agent`
installation profile links `AGENTS.md` for Codex and Claude without copying either
tool's caches, sessions, auth state, or raw auto-memory.

## Boundary

- `AGENTS.md`: stable, consciously public operating principles.
- `skills/`: reusable procedures in the open `SKILL.md` format.
- `memory/`: policy and templates only. Raw memories stay machine-local or in a
  separate private encrypted store.
- Secrets: 1Password only. Agent instructions are context, not a security boundary.

Promote knowledge deliberately:

1. An agent observes a possible preference locally.
2. The preference recurs or the user approves it.
3. Distill it into a short instruction, a reusable skill, or a private memory fact.
4. Review and prune public instructions quarterly.

Each folder under `skills/` must contain a `SKILL.md`. The installer links skills
individually, so existing third-party skills remain untouched.
