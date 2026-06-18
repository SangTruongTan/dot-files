#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="$(uname -s)"

info()    { echo "[zsh] $*"; }
success() { echo "[zsh] ✓ $*"; }

install_brew() {
  if command -v brew &>/dev/null; then
    success "Homebrew already installed."
    return
  fi
  if [[ "$OS" == "Darwin" ]]; then
    echo "Homebrew not found. Install it from https://brew.sh and re-run."
    exit 1
  fi
  info "Installing Homebrew (Linux)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  success "Homebrew installed."
}

install_zsh() {
  if command -v zsh &>/dev/null; then
    success "zsh already installed: $(zsh --version)"
    return
  fi
  info "Installing zsh..."
  brew install zsh
  success "zsh installed."
}

set_default_shell() {
  local zsh_path
  zsh_path="$(which zsh)"

  if ! grep -qx "$zsh_path" /etc/shells; then
    info "Adding $zsh_path to /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi

  if [[ "$SHELL" == "$zsh_path" ]]; then
    success "zsh is already the default shell."
    return
  fi

  info "Setting zsh as default shell..."
  chsh -s "$zsh_path"
  success "Default shell set to zsh. Re-login to apply."
}

install_zsh_plugins() {
  local plugins_dir=~/.zsh/plugins
  mkdir -p "$plugins_dir"
  declare -A plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
  )
  for plugin in "${!plugins[@]}"; do
    if [[ -d "$plugins_dir/$plugin" ]]; then
      success "$plugin already installed."
    else
      info "Installing $plugin..."
      git clone "${plugins[$plugin]}" "$plugins_dir/$plugin"
      success "$plugin installed."
    fi
  done
}

install_tools() {
  local tools=(jandedobbeleer/oh-my-posh/oh-my-posh fzf eza pyenv)
  for tool in "${tools[@]}"; do
    local name="${tool##*/}"
    if command -v "$name" &>/dev/null; then
      success "$name already installed."
    else
      info "Installing $name..."
      brew install "$tool"
      success "$name installed."
    fi
  done
}

link_config() {
  local target="$HOME/.zshrc"
  local source="$DOTFILES_DIR/zsh/.zshrc"

  if [[ -f "$target" && ! -L "$target" ]]; then
    info "Backing up $target → $target.bak"
    mv "$target" "$target.bak"
  fi

  ln -sf "$source" "$target"
  success "Linked ~/.zshrc → $source"
}

install_brew
install_zsh
set_default_shell
install_zsh_plugins
install_tools
link_config

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
