# Dotfiles

Personal Linux/WSL dotfiles, deployed with GNU Stow.

## Layout

Each top-level directory falls in one of three roles:

- **stow** — contents are symlinked into `$HOME` by `_sync-stow`.
- **tool** — contains scripts/files referenced by absolute path
  (`$HOME/dotfiles/<pkg>/...`), nothing symlinked.
- **both** — has stow-deployed files *and* helpers referenced by path.

| Package             | Role | Contents / target                                                      |
| ------------------- | ---- | ---------------------------------------------------------------------- |
| `alacritty/`        | stow | Alacritty terminal (`~/.config/alacritty/`)                            |
| `atuin/`            | stow | Atuin shell history (`~/.config/atuin/`)                               |
| `brew/`             | tool | `Brewfile` consumed by `_sync-brew` (excluded from stow via `.stowrc`) |
| `claude/`           | stow | Claude Code config (`~/.claude/settings.json`)                         |
| `codex/`            | stow | Codex CLI baseline (`~/.codex/config.toml`); sanitized stub, see `_sync-codex-skip-worktree` |
| `cursor/`           | stow | Cursor CLI hooks (`~/.cursor/hooks.json`)                              |
| `mise/`             | stow | mise runtime version manager                                           |
| `nvim/`             | stow | Neovim (LazyVim) config (`~/.config/nvim/`)                            |
| `opencode/`         | stow | opencode CLI config + `plugins/bell.ts` (rings tmux on `session.idle` / `permission.asked` / `question.asked`) |
| `scripts/`          | tool | Shared helpers referenced by absolute path (`tmux-bell.sh`, Claude `statusline-command.sh` + `statusline.py`) |
| `tmux/`             | stow | tmux config (`~/.config/tmux/tmux.conf`)                               |
| `whim/`             | stow | Whim window manager (Windows-side, synced via WSL)                     |
| `windows-terminal/` | stow | Windows Terminal config                                                |
| `wsl/`              | stow | WSL-side configs (`~/.wsl/`)                                           |
| `zsh/`              | both | `.zshrc` (stowed) plus `zsh-lib/` helpers sourced by path (excluded from stow via `.stowrc`) |

`docs/` is `.gitignore`d and not part of the repo.

Stow is configured via `.stowrc` (`--target=~`, `--no-folding`, ignores
`zsh-lib` and `Brewfile`). Tool-only packages whose files would otherwise be
stowed need a matching `--ignore` entry there (or exclusion from `_sync-stow`).

## Bootstrap

See `readme.md`. The `local-sync` function (defined in
`zsh/zsh-lib/.zshrc.sync`) is the single entry point: it syncs apt + brew
packages, stows every top-level package (auto-backing up conflicts), and on
WSL copies the relevant configs into the Windows user folder.

The current `HEAD` is written to `.last-local-sync`; `.zshrc` prompts to
re-run `local-sync` on shell startup if the repo has moved since.

## Conventions

- Edit configs in-repo, then re-stow (or just `local-sync`). Never edit the
  symlinked copies in `$HOME`.
- New tool? Add a new top-level dir mirroring the target path (e.g.
  `foo/.config/foo/...`) and `_sync-stow` will pick it up automatically.
- WSL-specific blocks in shared configs are delimited by `# @BEGIN_WSL` /
  `# @END_WSL` (and `_LIN` for Linux-only); see `_sync-wsl-config` for the
  `sed` transform.
- Private/host-specific zsh config goes in `~/.zshrc.local` (not tracked).
