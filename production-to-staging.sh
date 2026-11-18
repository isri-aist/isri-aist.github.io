#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO='isri-aist/isri-aist.github.io'
TARGET_REPO='n-ando/isri.github.io'
DIRECTION='production-to-staging'
export SOURCE_REPO TARGET_REPO DIRECTION
exec "$SCRIPT_DIR/sync-common.sh" "$@"
