#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root." >&2
    exit 1
fi

sudo -v

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "==> Deploying System Configurations..."

if [ -d "$DOTFILES_DIR/sddm/sddm-astronaut-theme-custom" ]; then
    echo "    Deploying SDDM custom theme..."
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r "$DOTFILES_DIR/sddm/sddm-astronaut-theme-custom" /usr/share/sddm/themes/
fi

if [ -d "$DOTFILES_DIR/sddm/sddm.conf.d" ]; then
    echo "    Deploying SDDM drop-in configurations..."
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -r "$DOTFILES_DIR/sddm/sddm.conf.d/." /etc/sddm.conf.d/
fi

if [ -f "$DOTFILES_DIR/sddm/sddm.conf" ]; then
    echo "    Deploying /etc/sddm.conf..."
    sudo cp "$DOTFILES_DIR/sddm/sddm.conf" /etc/sddm.conf
fi

if [ -d "$DOTFILES_DIR/system-assets" ]; then
    echo "    Deploying root system assets..."
    sudo cp -r "$DOTFILES_DIR/system-assets/." /
fi

echo "    System configurations deployed successfully."
