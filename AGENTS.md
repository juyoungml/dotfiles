# Repository guide

This public repository favors a minimal, fast, inspectable setup.

- Keep shell startup synchronous and cheap; optional integrations load last and only when installed.
- Use `uv` for Python versions, environments, dependencies, and Python CLI tools. Do not reintroduce Poetry or base Conda initialization.
- Installers must be idempotent, back up conflicts, support `--dry-run`, and never embed or request raw API keys.
- Public files may contain examples or safe secret references, never secret values or private memory.
- Add a tool or alias only when a recurring workflow justifies its startup and maintenance cost.
- Run `scripts/check.sh` after changes and update `docs/design.md` when architecture changes.
