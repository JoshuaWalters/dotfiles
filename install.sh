#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root." >&2
    exit 1
fi

sudo -v

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

"$DOTFILES_DIR/scripts/install-packages-dispatcher.sh"
"$DOTFILES_DIR/scripts/deploy-configs.sh"
"$DOTFILES_DIR/scripts/deploy-system.sh"

echo "Done. All tasks executed successfully."
