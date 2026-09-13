#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "==> Deploying User Configurations..."

STOW_PACKAGES=(hypr nvim backgrounds)

convert_to_backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "    Backing up ${target}..."
        mv "$target" "${target}.backup.$(date +%s)"
    fi
}

for pkg in "${STOW_PACKAGES[@]}"; do
    target="$HOME/.config/$pkg"
    [ "$pkg" = "backgrounds" ] && target="$HOME/Pictures/backgrounds"
    convert_to_backup_if_exists "$target"
done

mkdir -p "$HOME/.config" "$HOME/Pictures"
stow -d "$DOTFILES_DIR" -t "$HOME" "${STOW_PACKAGES[@]}"

echo "    User configurations linked successfully."
