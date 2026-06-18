# dotfiles

Personal shell and terminal configuration for macOS and Linux.

## What's included

| Component | Description |
|-----------|-------------|
| **zsh** | Shell config with fzf history search, autosuggestions, syntax highlighting, and oh-my-posh prompt |
| **tmux** | Terminal multiplexer config with Catppuccin theme, session persistence, and CPU/battery status bar |

## Prerequisites

- **macOS**: [Homebrew](https://brew.sh) must be installed before running the zsh installer.
- **Linux**: Homebrew will be installed automatically if missing.

## Install

Clone the repo and run the interactive installer:

```sh
git clone https://github.com/struong/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

You'll be prompted to choose which components to install. Each installer backs up any existing config before symlinking.

## Manual install

### tmux

```sh
bash tmux/install.sh
```

Installs tmux, [TPM](https://github.com/tmux-plugins/tpm), and symlinks `~/.tmux.conf`. After running:

1. Start or attach to a tmux session.
2. Reload config: `tmux source ~/.tmux.conf`
3. Install plugins: `prefix + I`

**Plugins:** tmux-sensible, tmux-resurrect, tmux-continuum, tmux-open, tmux-fzf, tmux-battery, tmux-cpu, catppuccin/tmux

**Theme switching:** `prefix + T` cycles through Catppuccin flavors (latte → frappe → macchiato → mocha).

### zsh

```sh
bash zsh/install.sh
```

Installs zsh, sets it as the default shell, clones plugins into `~/.zsh/plugins/`, installs CLI tools via Homebrew, and symlinks `~/.zshrc`.

**Plugins:** zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, fzf-tab

**Tools:** [oh-my-posh](https://ohmyposh.dev), [fzf](https://github.com/junegunn/fzf), [eza](https://github.com/eza-community/eza), [pyenv](https://github.com/pyenv/pyenv)

## License

[MIT](LICENSE)
