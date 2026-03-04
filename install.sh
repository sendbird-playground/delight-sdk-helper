#!/bin/bash
set -euo pipefail

APP_NAME="Delight SDK Helper"
REPO="sendbird-playground/delight-sdk-helper"
INSTALL_DIR="/Applications"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}==>${NC} $1"; }
warn()  { echo -e "${YELLOW}==>${NC} $1"; }
error() { echo -e "${RED}Error:${NC} $1"; exit 1; }

# Auth header for GitHub API (avoids rate limiting)
AUTH_HEADER=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  AUTH_HEADER=(-H "Authorization: token ${GITHUB_TOKEN}")
fi

# 1. Get latest release
info "Fetching latest release..."
RELEASE_JSON=$(curl -fsSL "${AUTH_HEADER[@]+"${AUTH_HEADER[@]}"}" "https://api.github.com/repos/${REPO}/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | grep '"tag_name"' | head -1 | sed 's/.*: "//;s/".*//')
DMG_URL=$(echo "$RELEASE_JSON" | grep '"browser_download_url".*\.dmg"' | head -1 | sed 's/.*: "//;s/".*//')

[ -z "$VERSION" ] && error "Failed to get latest version"
[ -z "$DMG_URL" ] && error "Failed to get DMG download URL"
info "Latest version: ${VERSION}"

# 2. Download DMG
TMPDIR_PATH=$(mktemp -d)
DMG_PATH="${TMPDIR_PATH}/DelightSDKHelper.dmg"
trap 'rm -rf "$TMPDIR_PATH"' EXIT

info "Downloading ${APP_NAME} ${VERSION}..."
curl -fSL -o "$DMG_PATH" "$DMG_URL"

# 3. Mount DMG
info "Installing..."
HDIUTIL_OUTPUT=$(hdiutil attach "$DMG_PATH" -nobrowse 2>&1)
MOUNT_DIR=$(echo "$HDIUTIL_OUTPUT" | tail -1 | awk -F'\t' '{print $NF}')
[ -z "$MOUNT_DIR" ] || [ ! -d "$MOUNT_DIR" ] && error "Failed to mount DMG"

# 4. Copy to /Applications
if [ -d "${INSTALL_DIR}/${APP_NAME}.app" ]; then
  warn "Removing existing installation..."
  rm -rf "${INSTALL_DIR}/${APP_NAME}.app"
fi
cp -R "${MOUNT_DIR}/${APP_NAME}.app" "${INSTALL_DIR}/"

# 5. Unmount
hdiutil detach "$MOUNT_DIR" -quiet 2>/dev/null || true

# 6. Remove quarantine
xattr -cr "${INSTALL_DIR}/${APP_NAME}.app"

info "${APP_NAME} ${VERSION} installed successfully!"
echo ""
echo "  Open from Spotlight or run:"
echo "  open -a '${APP_NAME}'"
echo ""
