#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================"
echo "       Dotfiles Installer       "
echo "================================"
echo ""

read -rp "Install tmux config? [y/N] " install_tmux
read -rp "Install zsh config?  [y/N] " install_zsh

if [[ "$install_tmux" =~ ^[Yy]$ ]]; then
  echo ""
  echo "--- tmux ---"
  bash "$DOTFILES_DIR/tmux/install.sh"
fi

if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
  echo ""
  echo "--- zsh ---"
  bash "$DOTFILES_DIR/zsh/install.sh"
fi

echo ""
echo "All done!"
