#!/usr/bin/env bash
set -euo pipefail
sudo -v

if [ "$#" -eq 0 ]; then
    echo "No package names provided for installation."
    exit 0
fi

if ! command -v paru &>/dev/null; then
    echo "Bootstrapping paru..."

    if ! sudo pacman -S --needed --noconfirm base-devel git; then
        echo "base-devel and git installation failed."
        exit 1
    fi

    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"' EXIT
    git clone https://aur.archlinux.org/paru.git "$tmp_dir"
    (cd "$tmp_dir" && makepkg -si --noconfirm)
    rm -rf "$tmp_dir"
    trap - EXIT
fi

echo "Installing packages: $*"

if ! paru -S --needed --noconfirm "$@"; then
    echo "Some packages failed to install." >&2
    exit 1
fi

echo "All packages installed."
