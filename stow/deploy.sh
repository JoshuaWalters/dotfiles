#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

echo "==> Deploying User Configurations..."

STOW_PKGS=(
    backgrounds
    hypr
    noctalia
    nvim
)

stow --adopt -d "$DOTFILES_DIR/stow" -t "$HOME" "${STOW_PKGS[@]}"

if [ -d "$DOTFILES_DIR/.git" ]; then
    git -C "$DOTFILES_DIR" restore stow
    git -C "$DOTFILES_DIR" clean -fd stow
fi

# This is just temporary, we need to instad
# 1. Check that the user is using hyprland
# 2. Stow the hyprland config if so
# 3. Then hyprctl reload if so
hyprctl reload || true
noctalia msg config-reload || true # This will also need changing!

echo "    User configurations linked successfully."
