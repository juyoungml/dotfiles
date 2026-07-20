# Memory policy

The public repository contains the policy, never raw memory. Machine-local agent
memory can contain session-derived preferences and private project context, so it
must not be mirrored from `~/.codex` or `~/.claude`.

When a fact is worth keeping across machines, put it in a separate private store
with these fields: `statement`, `source`, `reviewed_at`, `confidence`, and optional
`expires_at`. Promote only sanitized, stable principles into `../AGENTS.md`.
