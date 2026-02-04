#!/usr/bin/env bash
set -euo pipefail

# Repo root = parent of this script's directory (tools/)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_PATH="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

NGINX_PATH="/etc/nginx"

# ---- sanity checks ----
if [[ ! -d "${REPO_PATH}/.git" ]]; then
  echo "ERROR: ${REPO_PATH} is not a git repo (missing .git)"
  exit 1
fi

if [[ ! -d "$NGINX_PATH" ]]; then
  echo "ERROR: $NGINX_PATH does not exist"
  exit 1
fi

echo "Testing nginx config..."
sudo nginx -t

echo "Syncing ${NGINX_PATH} -> ${REPO_PATH} ..."

ME_USER="$(id -un)"
ME_GROUP="$(id -gn)"

# Sync CONTENTS of /etc/nginx into repo root, but protect repo/tooling files.
sudo rsync -a \
  --delete \
  --exclude=".git/" \
  --exclude="tools/" \
  --exclude=".gitignore" \
  --exclude="README.md" \
  --no-owner --no-group \
  --chown="${ME_USER}:${ME_GROUP}" \
  "${NGINX_PATH%/}/" "${REPO_PATH%/}/"

echo "Done."

