#!/usr/bin/env bash
set -euo pipefail

if [ ! -f /etc/os-release ]; then
    echo "/etc/os-release not found." >&2
    exit 1
fi

source /etc/os-release

OS_ID="${ID:-unknown}"
OS_ID_LIKE="${ID_LIKE:-}"

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    echo "OS_ID=${OS_ID}"
    echo "OS_ID_LIKE=${OS_ID_LIKE}"
fi
