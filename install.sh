#!/usr/bin/env bash
set -e
sudo -v

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Deploy user configurations
echo "==> Deploying User Configurations..."
PACKAGES=(hypr nvim backgrounds)

convert_to_backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "    Backing up ${target}..."
    mv "$target" "${target}.backup.$(date +%s)"
  fi
}

for pkg in "${PACKAGES[@]}"; do
  target="$HOME/.config/$pkg"
  [ "$pkg" = "backgrounds" ] && target="$HOME/Pictures/backgrounds"
  convert_to_backup_if_exists "$target"
done

mkdir -p "$HOME/.config" "$HOME/Pictures"
stow -d "$DOTFILES_DIR" -t "$HOME" "${PACKAGES[@]}"

# Deploy system configurations 
echo "==> Deploying System Configurations..."

if [ -d "$DOTFILES_DIR/sddm/sddm-astronaut-theme-custom" ]; then
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r "$DOTFILES_DIR/sddm/sddm-astronaut-theme-custom" /usr/share/sddm/themes/
fi

if [ -d "$DOTFILES_DIR/sddm/sddm.conf.d" ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -r "$DOTFILES_DIR/sddm/sddm.conf.d/." /etc/sddm.conf.d/
fi

if [ -f "$DOTFILES_DIR/sddm/sddm.conf" ]; then
    sudo cp "$DOTFILES_DIR/sddm/sddm.conf" /etc/sddm.conf
fi

if [ -d "$DOTFILES_DIR/system-assets" ]; then
    sudo cp -r "$DOTFILES_DIR/system-assets/." /
fi

echo "Done. All configs and system assets have been deployed."
