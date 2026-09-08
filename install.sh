#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Deploying User Configurations..."

# Clean up default hypr config if present and not already a symlink
if [ -d "$HOME/.config/hypr" ] && [ ! -L "$HOME/.config/hypr" ]; then
    echo "Backing up default Hyprland config..."
    mv "$HOME/.config/hypr" "$HOME/.config/hypr.backup.$(date +%s)"
fi

# Clean up default Pictures/backgrounds directory if present and not a symlink
if [ -d "$HOME/Pictures/backgrounds" ] && [ ! -L "$HOME/Pictures/backgrounds" ]; then
    echo "Backing up existing ~/Pictures/backgrounds..."
    mv "$HOME/Pictures/backgrounds" "$HOME/Pictures/backgrounds.backup.$(date +%s)"
fi

# Link User Configurations via Stow
mkdir -p "$HOME/.config" "$HOME/Pictures"
stow -d "$DOTFILES_DIR" -t "$HOME" hypr
stow -d "$DOTFILES_DIR" -t "$HOME" backgrounds

echo "==> Deploying System Configurations..."

# Deploy SDDM theme and drop-in configurations
sudo mkdir -p /usr/share/sddm/themes
sudo cp -r "$DOTFILES_DIR/sddm/sddm-astronaut-theme-custom" /usr/share/sddm/themes/

if [ -d "$DOTFILES_DIR/sddm/sddm.conf.d" ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -r "$DOTFILES_DIR/sddm/sddm.conf.d"/* /etc/sddm.conf.d/
fi

if [ -f "$DOTFILES_DIR/sddm/sddm.conf" ]; then
    sudo cp "$DOTFILES_DIR/sddm/sddm.conf" /etc/sddm.conf
fi

# Deploy System Assets
if [ -d "$DOTFILES_DIR/system-assets" ]; then
    sudo cp -r "$DOTFILES_DIR/system-assets"/* /
fi

echo "Done. All configs and system assets have been deployed."
