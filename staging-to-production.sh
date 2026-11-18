#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO='n-ando/isri.github.io'
TARGET_REPO='isri-aist/isri-aist.github.io'
DIRECTION='staging-to-production'
export SOURCE_REPO TARGET_REPO DIRECTION
exec "$SCRIPT_DIR/sync-common.sh" "$@"
