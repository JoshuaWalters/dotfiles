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
    echo "Deploying SDDM custom theme..."
    sudo mkdir -p /usr/local/share/sddm/themes
    sudo rsync -a --delete "$SDDM_SRC/sddm-astronaut-theme-custom/" /usr/local/share/sddm/themes/sddm-astronaut-theme-custom/
fi

if [ -d "$SDDM_SRC/sddm.conf.d" ]; then
    echo "Deploying SDDM drop-in configurations..."
    sudo mkdir -p /etc/sddm.conf.d
    sudo rsync -a "$SDDM_SRC/sddm.conf.d/" /etc/sddm.conf.d/
fi

echo "System configurations deployed successfully."
