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
bash "$DOTFILES_DIR/stow/stow.sh"
# "$DOTFILES_DIR/scripts/deploy-system.sh"
# ^ This line has been commented out until SDDM deployment is reworked!

echo "Done. All tasks executed successfully."
