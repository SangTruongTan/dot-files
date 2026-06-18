#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="$(uname -s)"

info()    { echo "[zsh] $*"; }
success() { echo "[zsh] ✓ $*"; }

install_zsh() {
  if command -v zsh &>/dev/null; then
    success "zsh already installed: $(zsh --version)"
    return
  fi
  info "Installing zsh..."
  case "$OS" in
    Darwin) brew install zsh ;;
    Linux)  sudo apt-get install -y zsh ;;
  esac
  success "zsh installed."
}

install_omz() {
  if [[ -d ~/.oh-my-zsh ]]; then
    success "Oh My Zsh already installed."
    return
  fi
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "Oh My Zsh installed."
}

install_zsh_plugins() {
  local plugins_dir=~/.oh-my-zsh/custom/plugins
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

install_oh_my_posh() {
  if command -v oh-my-posh &>/dev/null; then
    success "oh-my-posh already installed."
    return
  fi
  info "Installing oh-my-posh..."
  case "$OS" in
    Darwin) brew install jandedobbeleer/oh-my-posh/oh-my-posh ;;
    Linux)  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin ;;
  esac
  success "oh-my-posh installed."
}

install_fzf() {
  if command -v fzf &>/dev/null; then
    success "fzf already installed."
    return
  fi
  info "Installing fzf..."
  case "$OS" in
    Darwin) brew install fzf ;;
    Linux)  sudo apt-get install -y fzf ;;
  esac
  success "fzf installed."
}

install_eza() {
  if command -v eza &>/dev/null; then
    success "eza already installed."
    return
  fi
  info "Installing eza..."
  case "$OS" in
    Darwin) brew install eza ;;
    Linux)
      sudo apt-get install -y gpg wget
      sudo mkdir -p /etc/apt/keyrings
      wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
      echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | sudo tee /etc/apt/sources.list.d/gierens.list
      sudo apt-get update && sudo apt-get install -y eza
      ;;
  esac
  success "eza installed."
}

install_pyenv() {
  if command -v pyenv &>/dev/null; then
    success "pyenv already installed."
    return
  fi
  info "Installing pyenv..."
  case "$OS" in
    Darwin) brew install pyenv ;;
    Linux)  curl https://pyenv.run | bash ;;
  esac
  success "pyenv installed."
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

install_zsh
install_omz
install_zsh_plugins
install_oh_my_posh
install_fzf
install_eza
install_pyenv
link_config

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
