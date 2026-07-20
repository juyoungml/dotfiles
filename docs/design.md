# Design and decisions

## Shell design

Both Bash and Zsh source three explicit, shared modules in a fixed order. Environment
and paths load first, the small alias/function set loads next, and capability-detected
integrations load last. There is no framework, plugin manager, prompt subprocess, or
automatic runtime activation. That keeps startup fast and makes every behavior easy
to locate and remove.

Python work is `uv`-first: `uv sync`, `uv run`, `uv add`, `uv python install`, and
`uv tool install`. A global `pip`, Poetry, and base Conda initialization are omitted
because they create overlapping ownership and slow or mutate every shell.

Machine-only paths belong in `~/.config/dotfiles/local.sh`. It is copied from an
example, not symlinked into Git. Secrets must never be sourced there.

## Authentication

Authentication cannot safely be bypassed. `dots auth` makes it a deliberate one-time
step:

- GitHub uses `gh auth login --web --git-protocol ssh`; the OAuth token is stored in
  the OS credential store when available.
- Hugging Face uses `hf auth login`, which supports browser/device authentication and
  local token refresh.
- 1Password desktop/CLI integration uses biometric unlock. It is reserved for tools
  that actually require raw API credentials.

`dots secrets -- command` resolves `op://` references only for that child process.
It does not export tokens from `.bashrc`/`.zshrc`, wrap the whole login shell, or put
secret values in argv/history. Environment injection is convenient, but same-user
processes may still observe it, so keep the command scope narrow.

## Agent boundary

The public agent layer contains reviewed instructions, reusable skills, and memory
policy. Raw `~/.claude` and `~/.codex` directories contain sessions, caches, auth,
inferred preferences, and private project context; they are never mirrored.

The promotion flow is local observation → repeated/explicit confirmation → reviewed
public instruction, reusable skill, or private memory fact. Instructions guide an
agent but do not enforce security; permissions and secret managers do that.

Cluster-specific behavior follows the same boundary. Stable operational habits
such as uv-first Python, canonical VAST paths, Slurm monitoring, and VAST-friendly
inspection belong in a public skill or shell helper. Runtime endpoints, raw agent
state, project secrets, node exclusions, and job-name prefixes stay local or
project-specific.

## Public bootstrap

`bootstrap.sh` is the canonical entrypoint and is also recognized by GitHub
Codespaces. `public/bashrc` is a small vanity endpoint intended for
`https://juyoungml.site/bashrc`; it downloads the canonical bootstrap to a temporary
file before execution.

The readable path is preferred:

```sh
curl -fsSLo /tmp/dotfiles https://juyoungml.site/bashrc
less /tmp/dotfiles
sh /tmp/dotfiles --profile dev
```

The short path is convenient but executes mutable remote code:

```sh
curl -fsSL https://juyoungml.site/bashrc | sh -s -- --profile dev
```

For stronger integrity, publish immutable tagged release assets plus SHA-256
checksums and pin `DOTFILES_REF` to that tag. A custom domain improves memorability,
not trust by itself.

## Why a small custom deployer

The current needs are readable files, a few profiles, conflict backups, and secure
local overlays. A small symlink deployer meets those needs without imposing a state
model or transformed filenames. If machine-specific templates and secret rendering
become a recurring need, the deploy mapping is isolated enough to migrate to
Chezmoi. The shell/config source files remain manager-independent.
