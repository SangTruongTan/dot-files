#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="$(uname -s)"

info()    { echo "[tmux] $*"; }
success() { echo "[tmux] ✓ $*"; }

install_tmux() {
  if command -v tmux &>/dev/null; then
    success "tmux already installed: $(tmux -V)"
    return
  fi
  info "Installing tmux..."
  case "$OS" in
    Darwin) brew install tmux ;;
    Linux)
      if command -v apt-get &>/dev/null; then
        sudo apt-get install -y tmux
      elif command -v dnf &>/dev/null; then
        sudo dnf install -y tmux
      else
        echo "Unsupported package manager. Install tmux manually." && exit 1
      fi
      ;;
  esac
  success "tmux installed."
}

install_tpm() {
  if [[ -d ~/.tmux/plugins/tpm ]]; then
    success "TPM already installed."
    return
  fi
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  success "TPM installed."
}

link_config() {
  local target="$HOME/.tmux.conf"
  local source="$DOTFILES_DIR/tmux/.tmux.conf"

  if [[ -f "$target" && ! -L "$target" ]]; then
    info "Backing up $target → $target.bak"
    mv "$target" "$target.bak"
  fi

  ln -sf "$source" "$target"
  success "Linked ~/.tmux.conf → $source"
}

install_tmux
install_tpm
link_config

echo ""
echo "Done!"
echo ""
echo "Next steps:"
echo "  1. Start tmux (or attach to an existing session)"
echo "  2. Reload the config:   tmux source ~/.tmux.conf"
echo "  3. Install plugins:     prefix + I"
