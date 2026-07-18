# dotfiles

macOS development environment, managed with [Nix](https://nixos.org) + [Home Manager](https://github.com/nix-community/home-manager).

The code has the details; this README is the map of intentions. Each section explains *why* a piece is shaped the way it is, so you can steal the idea instead of the config.

## Setup

```sh
git clone git@github.com:0xlkda/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
nix run home-manager -- switch --flake .#alex
```

Paths assume `~/code/dotfiles` and user `alex` — adjust [`home.nix`](home.nix) if yours differ. Machine-local files (`zsh/private_aliases`, TLS certs, signing keys) are gitignored and optional; everything degrades gracefully when they're absent.

---

## The landscape

### One working copy, no install step

[`home.nix`](home.nix) links every config (`~/.zshrc`, `~/.config/nvim`, …) back into this repo with `mkOutOfStoreSymlink` — *out of store* meaning the links point at the live working copy, not an immutable Nix store snapshot. Edit a file here and it's already live; no rebuild, no re-run. Nix's job is narrowed to the two things that benefit from being declarative: the package list and the symlink map. [`install`](install) is the pre-Nix version of the same idea, kept for machines without Nix.

### One theme, one switch

Light/dark is a *system-wide* state, not a per-app setting. [`tmux/theme.sh`](tmux/theme.sh) is the single switch: it recolors the tmux status line, rewrites which palette [`alacritty.yml`](alacritty/alacritty.yml) imports, sets Claude Code's theme, and pings every running Neovim over a per-pane RPC socket (created in [`init.lua`](nvim/init.lua)) so they re-run `SyncTheme()` instantly. The current theme lives in one place — tmux's `@theme` option — and everything else reads from it (Neovim re-checks on `FocusGained`, so even a freshly focused editor agrees). Toggle from anywhere: `prefix T` in tmux, `<leader>T` in Neovim, `Cmd+T` in Alacritty. Palette is [Rosé Pine](https://rosepinetheme.com) in all layers, so a toggle never changes "which colors", only "which side".

### The Mac is the server; every device is a viewport

The desktop tmux session is the one true workspace; phones and iPads SSH in (via Tailscale) and get *viewports onto it*, not copies of it. [`zsh/zprofile`](zsh/zprofile) auto-attaches interactive SSH logins through [`tmux/attach-mobile.sh`](tmux/attach-mobile.sh), which gives each device its own **grouped session** — same windows, independent focus — auto-named from the client IP when the device doesn't introduce itself. Combined with `aggressive-resize` and `window-size latest` ([`tmux.conf`](tmux/tmux.conf)), a phone only shrinks the window it is actually looking at; the iPad parked on another window keeps full size. The script's header comment documents the one hard tmux limit (two devices on the *same* window must share a size) and the chosen policy for it.

Small things that make remote-first livable:

- **Copy works from any device**: [`osc52-copy.sh`](tmux/osc52-copy.sh) fans a yank out to macOS `pbcopy`, the tmux buffer, *and* an OSC 52 escape to every connected client's tty — so text yanked on the Mac lands on the iPhone clipboard you're actually holding.
- **Scroll direction is per-session, opt-in** ([`scroll-direction.sh`](tmux/scroll-direction.sh)): touch devices scroll "backwards" relative to a mouse wheel, but auto-detection proved worse than a `prefix S` toggle. The copy-mode auto-cancel is gated so iPad scroll inertia can't accidentally cancel on the first wheel event.
- **The status bar shows where the *other* device is**: clicking the device name on the right jumps this client to the window that device is viewing ([`theme.sh`](tmux/theme.sh) + the `follow_other` binding in `tmux.conf`).

### Vim is the grammar, everywhere

The same muscle memory should work in every text surface: vi-mode in zsh ([`keybindings.zsh`](zsh/conf.d/keybindings.zsh)), vi keys in tmux copy-mode, and — the unusual one — [`DefaultKeyBinding.dict`](DefaultKeyBinding.dict), which teaches *every native macOS text field* readline motions plus comment/line-manipulation chords. `Ctrl-L` clears the screen from inside Neovim or shell alike (`tmux.conf` sniffs the foreground process). Starship flips its prompt symbol with zsh's vi mode, so you always know which mode you're in.

### Code is read folded

The editor's default view of a file is its *outline*. Custom treesitter fold queries ([`folds.scm`](nvim/after/queries/typescript/folds.scm)) fold every meaningful block; `foldlevelstart=1` opens files as a table of contents; `z1f`–`z9f` jump straight to a depth. Fold headers keep full syntax highlighting via a treesitter-aware `foldtext` ([`config/folding.lua`](nvim/lua/config/folding.lua)) — a folded file should read like code, not like grey placeholders. Because folds are the reading mode, a lot of `init.lua` is defense against things that destroy them: formatting saves/restores the view, external-file reloads re-parse and re-fold without moving the cursor, Telescope restores folds after a jump, and insert-mode temporarily switches to `manual` folding so typing can't trigger expensive re-folds. Folds are also clickable — the mouse toggles them in the fold column.

### Nix for machines *and* for projects

The same reproducibility story at two scales. Machine scale: [`flake.nix`](flake.nix) pins nixpkgs and declares every CLI tool in [`home.nix`](home.nix) — no Homebrew drift. Project scale: [`environments/`](environments) holds one-line direnv (`use nix`) and `shell.nix` templates; the `newnode` alias symlinks them into a fresh project so `cd` gives you node + tooling without global installs. The prompt ([`starship.toml`](starship/starship.toml)) shows a ❄ when you're inside a nix shell — environment state should be visible, not remembered.

### Git: small verbs, worktrees, SSH signing

[`gitconfig`](git/gitconfig) signs commits with a plain **SSH key** instead of GPG (`gpg.format = ssh`) — one less key ecosystem to maintain — and delegates HTTPS credentials to `gh`, so no tokens live in git config. The alias layer ([`git.zsh`](zsh/conf.d/git.zsh)) is a vocabulary of one-to-three-letter verbs for the inner loop (`gst`, `gd`, `ga` = `add -p`, `wip` = stage-all-and-WIP-commit), plus a few codified habits: `try` starts a timestamped throwaway branch, `gsquash` soft-resets to the merge-base with main. Worktrees are the default multitasking model: [`clone-for-worktree.sh`](bin/clone-for-worktree.sh) sets up the bare-repo layout where branches live as sibling directories, and `Ctrl-T` in the shell fuzzy-jumps between them.

### The shell remembers so you don't

100k lines of history, shared live across every pane, aggressively deduplicated, with space-prefix opt-out for secrets ([`options.zsh`](zsh/conf.d/options.zsh) — every option has a one-line comment saying what it does). Retrieval is fuzzy, not prefix-based: `Ctrl-R` pipes unique history through `fzy`; `Ctrl-G` does the same for directories under `~/code` ([`keybindings.zsh`](zsh/conf.d/keybindings.zsh)). The pattern throughout: `fd`/`rg` produce candidates, `fzy` picks one — the same three tools compose every jump.

### macOS built-ins over installed tools

[`macos.zsh`](zsh/conf.d/macos.zsh) is a tour of `/usr/sbin` "hidden gems", wrapped so they're actually usable: `bgrun` runs heavy jobs at background CPU/IO priority (`taskpolicy`), `shot`/`rec` do screenshots and screen recording (`screencapture`), `coldrun` benchmarks with a genuinely cold disk cache (`purge`), `treesnap`/`treecheck` detect filesystem drift (`mtree`). The [`macos`](macos) script sets system defaults — mostly turning *off* autocorrect-everything so the OS stops editing your text.

### Vietnamese input, per pane

[`telex-scope.sh`](tmux/telex-scope.sh) + tmux focus hooks tell the GõTelex IME which pane is active, so each pane keeps its *own* VN/EN typing mode — the editor pane can stay English while the notes pane types Vietnamese. No-op when the IME isn't running.

### Quiet performance choices

Scattered, deliberate, each commented at the source: `matchparen` is disabled (it re-runs on every cursor move and drags in deep nesting); completion menus cap at 8 items; Telescope refuses to preview files over 2 MB; the 1Password and Tailscale completions are vendored into [`zsh/functions/`](zsh/functions) so startup never shells out to generate them; tmux `escape-time` is 0 so Esc in vim is instant.

---

## Layout

| Path | What |
|---|---|
| `flake.nix` / `home.nix` | packages + symlink map (the whole "install") |
| `zsh/` | entry files + modular `conf.d/` (options, keybindings, aliases, git, macOS) |
| `nvim/` | single-file `init.lua` + fold queries, filetype tweaks |
| `tmux/` | config + the theme/mobile/scroll/copy scripts described above |
| `bin/` | small utilities (`clone-for-worktree.sh`, `countdown.sh`, `tmux-selector.sh`) |
| `git/` | gitconfig, global ignore |
| `alacritty/`, `starship/` | terminal + prompt (Rosé Pine light/dark) |
| `environments/` | per-project nix/direnv templates |
| `macos`, `DefaultKeyBinding.dict` | system defaults, native-textfield keybindings |
