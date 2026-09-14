#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root." >&2
    exit 1
fi

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export DOTFILES_DIR

sudo -v

bash "$DOTFILES_DIR/scripts/install-packages-dispatcher.sh"
bash "$DOTFILES_DIR/stow/deploy.sh"
bash "$DOTFILES_DIR/system/deploy.sh"

echo "Done. All tasks executed successfully."
