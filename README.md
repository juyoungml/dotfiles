# dotfiles

A minimal, `uv`-first, agent-native development setup for macOS and Linux. It is
designed to be read, changed incrementally, and removed without mystery.

## Quick start

Inspect before running:

```sh
git clone https://github.com/juyoungml/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run --profile dev
./install.sh --profile dev
dots auth
dots doctor
```

When the vanity endpoint is deployed:

```sh
curl -fsSL https://juyoungml.site/bashrc | sh -s -- --profile dev
```

`install.sh` backs up conflicts instead of overwriting them. Re-running it is safe.
Use `--no-packages` when you only want to re-apply links.

## Profiles

| Profile | Purpose |
| --- | --- |
| `core` | fast shell, Git, tmux, uv, and daily CLI tools |
| `dev` | core plus lint/format tools, 1Password CLI, and the Hugging Face CLI |
| `agent` | dev plus reviewed global agent instructions and personal skill links |

The `agent` profile backs up existing global instruction files before linking. It
does not copy session logs, caches, auto-memory, credentials, or third-party skills.

## Daily interface

```sh
dots doctor                 # what is installed, linked, or unauthenticated?
dots auth                   # one-time op + gh + hf setup
dots secrets -- python app.py  # inject 1Password refs for one process
dots explain auth           # understand a design decision
dots explain tmux           # beginner tmux guide and key reference
dots quiz                   # self-check the repo contents
dots update                 # fast-forward and re-link
```

Machine-only files live in `~/.config/dotfiles/`:

- `git.local`: name/email and conditional work identities.
- `local.sh`: machine paths and non-secret preferences.
- `secrets.env`: optional `op://` references; never secret values in Git.

## Modern stack choices

- Python: `uv` owns interpreters, environments, project dependencies, and Python CLIs.
- Packages: Homebrew bundles on macOS; explicit apt/dnf packages on Linux.
- Navigation and inspection: zoxide/fzf, delta, gdu, Glances, and watchexec.
- GPU servers: nvitop is installed as a uv-managed CLI in developer profiles.
- Shell: framework-free Bash and Zsh sharing a few ordered modules.
- Git: fast-forward pulls, histogram diffs, `zdiff3`, and identity kept local.
- Auth: browser OAuth/keychain for GitHub and Hugging Face; scoped 1Password runtime injection elsewhere.
- Agents: portable public instructions/skills with raw memory kept local/private.

The old Poetry, Miniconda, global pip, NodeSource, and pinned CUDA installers were
removed. GPU/driver provisioning is machine and distribution specific; it belongs
in a separate host playbook rather than a universal shell bootstrap.

## Verification and publishing

```sh
scripts/check.sh
```

Before changing the repository visibility to public, scan the full Git history with
Gitleaks or GitHub secret scanning—not only the current tree. If a credential ever
appeared, revoke/rotate it before rewriting history. Then publish `public/bashrc` as
the `/bashrc` route in the website repository or configure a server-side route to
serve it.

See [the design notes](docs/design.md) and [the research report](docs/report.html).
