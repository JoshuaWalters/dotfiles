#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root." >&2
    exit 1
fi

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "==> Detecting operating system..."

source "$DOTFILES_DIR/scripts/os/get-os-ids.sh"

echo "    OS_ID: $OS_ID (OS_ID_LIKE: ${OS_ID_LIKE:-none})"

case " ${OS_ID_LIKE:-$OS_ID} " in
    *" arch "*)
        OS_FAMILY="arch"
        ;;
    *" fedora "*|*" rhel "*)
        OS_FAMILY="fedora"
        ;;
    *" debian "*)
        OS_FAMILY="debian"
        ;;
    *)
        echo "Unsupported operating system ($OS_ID)." >&2
        exit 1
        ;;
esac

resolve_os_asset() {
    local filename="$1"
    local specific_path="$DOTFILES_DIR/scripts/os/$OS_ID/$filename"
    local family_path="$DOTFILES_DIR/scripts/os/$OS_FAMILY/$filename"

    if [ -f "$specific_path" ]; then
        echo "$specific_path"
    elif [ -f "$family_path" ]; then
        echo "$family_path"
    fi
}

PKG_INSTALLER="$(resolve_os_asset "install-packages.sh")"
PKG_MANIFEST="$(resolve_os_asset "packages.txt")"

if [ -z "$PKG_INSTALLER" ]; then
    echo "No package installer script found for $OS_ID or family $OS_FAMILY." >&2
    exit 1
fi

if [ -n "$PKG_MANIFEST" ]; then
    echo "Loading package manifest: $PKG_MANIFEST"
    mapfile -t PACKAGES_TO_INSTALL < "$PKG_MANIFEST"

    if [ "${#PACKAGES_TO_INSTALL[@]}" -gt 0 ]; then
        echo "Running installer: $PKG_INSTALLER"
        chmod +x "$PKG_INSTALLER"
        "$PKG_INSTALLER" "${PACKAGES_TO_INSTALL[@]}"
    else
        echo "Manifest is empty. Skipping package installation."
    fi
else
    echo "No packages.txt found for $OS_ID or $OS_FAMILY. Skipping package install."
fi
