#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/distribute_signing_keys.sh"
"$BASE_DIR/submodules/max/scripts/setup-cache.sh"
"$SCRIPT_DIR/cbp/init_app.sh"
