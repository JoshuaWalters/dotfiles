#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root." >&2
    exit 1
fi

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

echo "==> Detecting operating system..."
source "$DOTFILES_DIR/scripts/get-os-ids.sh"
echo "ID: $OS_ID"
echo "ID_LIKE: ${OS_ID_LIKE:-none}"

resolve_package_asset() {
    local filename="$1"
    local candidate

    candidate="$DOTFILES_DIR/scripts/packages/$OS_ID/$filename"
    if [ -f "$candidate" ]; then
        echo "$candidate"
        return 0
    fi

    for like in ${OS_ID_LIKE:-}; do
        candidate="$DOTFILES_DIR/scripts/packages/$like/$filename"
        if [ -f "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

if ! PKG_INSTALLER="$(resolve_package_asset "install.sh")"; then
    echo "No install.sh found in $OS_ID or fallback ${OS_ID_LIKE:-none}." >&2
    exit 1
fi

if ! PKG_MANIFEST="$(resolve_package_asset "packages.txt")"; then
    echo "No packages.txt found in $OS_ID or fallback ${OS_ID_LIKE:-none}." >&2
    exit 1
fi

echo "==> Loading package manifest: $PKG_MANIFEST"
mapfile -t PACKAGES_TO_INSTALL < <(grep -v -E '^\s*(#|$)' "$PKG_MANIFEST" || true)

if [ "${#PACKAGES_TO_INSTALL[@]}" -eq 0 ]; then
    echo "Package manifest $PKG_MANIFEST is empty." >&2
    exit 1
fi

echo "==> Running installer: $PKG_INSTALLER"
chmod +x "$PKG_INSTALLER"
"$PKG_INSTALLER" "${PACKAGES_TO_INSTALL[@]}"
