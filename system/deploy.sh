#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root." >&2
    exit 1
fi

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

sudo -v

echo "==> Deploying system configurations..."

SDDM_SRC="$DOTFILES_DIR/system/sddm"

if [ -d "$SDDM_SRC/sddm-astronaut-theme-custom" ]; then
    sudo mkdir -p /usr/local/share/sddm/themes
    sudo rsync -a --delete "$SDDM_SRC/sddm-astronaut-theme-custom/" /usr/local/share/sddm/themes/sddm-astronaut-theme-custom/
fi

if [ -d "$SDDM_SRC/sddm.conf.d" ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo rsync -a "$SDDM_SRC/sddm.conf.d/" /etc/sddm.conf.d/
fi

BG_SRC="$DOTFILES_DIR/system/1920x1080_Abyssal.png"

if [ -f "$BG_SRC" ]; then
    sudo install -Dm644 "$BG_SRC" /usr/local/share/backgrounds/1920x1080_Abyssal.png
fi

echo "System configurations deployed successfully."
