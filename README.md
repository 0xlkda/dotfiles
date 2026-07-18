# dotfiles

macOS setup managed with [Nix](https://nixos.org) + [Home Manager](https://github.com/nix-community/home-manager). `home.nix` symlinks every config back into this working copy, so edits here take effect immediately.

## Layout

| Path | What |
|---|---|
| `flake.nix` / `home.nix` | Home Manager config: packages + dotfile symlinks |
| `zsh/` | `zshrc`, `zshenv`, `zprofile` + modular `conf.d/` (aliases, git, keybindings, macOS) |
| `nvim/` | Neovim (lazy.nvim, treesitter, LSP) |
| `tmux/` | tmux config + scripts, incl. `attach-mobile.sh` (per-device grouped sessions for SSH-from-phone) |
| `bin/` | Small utilities (`countdown.sh`, `tmux-selector.sh`) |
| `git/` | gitconfig (SSH commit signing), global ignore |
| `alacritty/`, `starship/` | Terminal + prompt |
| `environments/` | direnv / nix-shell templates for per-project setups |
| `macos` | `defaults write` system preferences script |
| `install` | Legacy symlink script (superseded by Home Manager) |

## Setup

```sh
git clone git@github.com:0xlkda/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
nix run home-manager -- switch --flake .#alex
```

Paths assume the repo lives at `~/code/dotfiles` and a user named `alex` — adjust `home.nix` and `zsh/zshrc` if yours differ.

Machine-local files (`zsh/private_aliases`, `git/allowed_signers`, TLS certs, …) are gitignored and optional; everything degrades gracefully when they're absent.
