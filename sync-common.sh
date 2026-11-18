#!/usr/bin/env bash
set -euo pipefail

# Synchronize the content of two unrelated GitHub Pages repositories.
# Entry-point scripts set SOURCE_REPO, TARGET_REPO and DIRECTION.
# Dependencies: bash, git, rsync, mktemp, diff. Requires git credentials for push.

SOURCE_BRANCH="${SOURCE_BRANCH:-main}"
TARGET_BRANCH="${TARGET_BRANCH:-main}"
SOURCE_URL="${SOURCE_URL:-https://github.com/${SOURCE_REPO}.git}"
TARGET_URL="${TARGET_URL:-https://github.com/${TARGET_REPO}.git}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--dry-run] [--apply] [--push] [--pr] [--help]
  --dry-run   List planned changes (default; no commits or pushes).
  --apply     Commit changes in a local temporary clone without pushing.
  --push      Commit changes and push to a new sync branch on the destination.
  --pr        With --push, create a pull request via GitHub CLI (gh).

Common options:
  --include-path PATH   Sync only this relative path (repeatable). Default: all files.
  --delete              Delete destination-only files (not recommended).
  --help                Show this help.

Always protected: _config.yml, CNAME, .git/, .github/, and these sync scripts.
Neither repo's default branch is modified by this script.
USAGE
}

MODE=dry-run
CREATE_PR=0
DELETE=0
INCLUDE_PATHS=()
while (($#)); do
  case "$1" in
    --dry-run) MODE=dry-run ;;
    --apply) MODE=apply ;;
    --push) MODE=push ;;
    --pr) CREATE_PR=1 ;;
    --delete) DELETE=1 ;;
    --include-path)
      (($# >= 2)) || { echo 'Missing path after --include-path' >&2; exit 2; }
      case "$2" in
        /*|..|../*|*/../*|*/..) echo "Unsafe path: $2" >&2; exit 2 ;;
      esac
      INCLUDE_PATHS+=("$2"); shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done
if ((CREATE_PR)) && [[ "$MODE" != push ]]; then
  echo '--pr requires --push' >&2; exit 2
fi
for program in git rsync mktemp; do command -v "$program" >/dev/null || { echo "Missing dependency: $program" >&2; exit 1; }; done
if ((CREATE_PR)); then command -v gh >/dev/null || { echo 'GitHub CLI (gh) is required for --pr' >&2; exit 1; }; fi

INITIAL_DIR="$PWD"
TMPDIR_SYNC="$(mktemp -d "${TMPDIR:-/tmp}/isri-sync.XXXXXX")"
trap 'rm -rf "$TMPDIR_SYNC"' EXIT
SRC="$TMPDIR_SYNC/source"
DST="$TMPDIR_SYNC/target"

echo "Source:      $SOURCE_REPO ($SOURCE_BRANCH)"
echo "Destination: $TARGET_REPO ($TARGET_BRANCH)"
echo "Mode:        $MODE"
git clone --quiet --depth 1 --branch "$SOURCE_BRANCH" "$SOURCE_URL" "$SRC"
git clone --quiet --depth 1 --branch "$TARGET_BRANCH" "$TARGET_URL" "$DST"

EXCLUDES=(
  --exclude='/.git/'
  --exclude='/_config.yml'
  --exclude='/CNAME'
  --exclude='/.github/'
)

# Only regular tracked files (including binary assets) are copied. rsync does not
# depend on shared Git history, avoiding unrelated-history merges.
RSYNC_OPTS=(-a --checksum --itemize-changes "${EXCLUDES[@]}")
if ((DELETE)); then RSYNC_OPTS+=(--delete); fi
if ((${#INCLUDE_PATHS[@]})); then
  # Protect unspecified paths by using rsync filter to include path ancestors.
  FILTERS=()
  for path in "${INCLUDE_PATHS[@]}"; do
    path="${path#./}"; path="${path%/}"
    [[ -n "$path" ]] || { echo 'Empty include path' >&2; exit 2; }
    case "$path" in
      _config.yml|CNAME|.git|.git/*|.github|.github/*|sync-common.sh|staging-to-production.sh|production-to-staging.sh)
        echo "Protected path cannot be included: $path" >&2; exit 2 ;;
    esac
    FILTERS+=(--include="/$path" --include="/$path/***")
    parent="$path"
    while [[ "$parent" == */* ]]; do
      parent="${parent%/*}"
      FILTERS+=(--include="/$parent/")
    done
  done
  # Protect include-path mode from deletion of unrelated content.
  if ((DELETE)); then echo 'Combining --delete and --include-path is not supported' >&2; exit 2; fi
  RSYNC_OPTS+=("${FILTERS[@]}" --exclude='*')
fi

# Do not copy untracked files from the working tree (fresh clones contain none).
if [[ "$MODE" == dry-run ]]; then
  rsync "${RSYNC_OPTS[@]}" --dry-run "$SRC/" "$DST/"
  echo 'Dry run only. Use --push to open a sync branch in the destination.'
  exit 0
fi

rsync "${RSYNC_OPTS[@]}" "$SRC/" "$DST/"
cd "$DST"
git add -A
if git diff --cached --quiet; then echo 'No changes to synchronize.'; exit 0; fi
printf '\nStaged summary:\n'
git diff --cached --stat

BRANCH="sync/${DIRECTION}-$(date -u +%Y%m%dT%H%M%SZ)"
git switch --quiet -c "$BRANCH"
git -c user.name="ISRI Sync" -c user.email="isri-sync@users.noreply.github.com" commit -m "Sync ${DIRECTION} content" --quiet
if [[ "$MODE" == apply ]]; then
  # Export commit as a bundle before cleanup, so --apply remains useful.
  BUNDLE="${OUTPUT_BUNDLE:-$INITIAL_DIR/isri-${DIRECTION}-sync.bundle}"
  git bundle create "$BUNDLE" "$BRANCH" >/dev/null
  echo "Created local bundle: $BUNDLE"
  exit 0
fi

git push --set-upstream origin "$BRANCH"
echo "Pushed: https://github.com/${TARGET_REPO}/tree/${BRANCH}"
if ((CREATE_PR)); then
  gh pr create --repo "$TARGET_REPO" --base "$TARGET_BRANCH" --head "$BRANCH" \
    --title "Sync ${DIRECTION} changes" \
    --body "Synchronize site contents from ${SOURCE_REPO} (${SOURCE_BRANCH}). Repository-specific _config.yml and CNAME are preserved. Please review page changes before merging."
else
  echo "Create PR: https://github.com/${TARGET_REPO}/compare/${TARGET_BRANCH}...${BRANCH}?expand=1"
fi
