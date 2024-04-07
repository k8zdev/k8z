#!/usr/bin/env bash

APP_NAME="k8z"
BASEDIR="./build/macos/"
CREATE_DMG=$(which create-dmg)
VOLUME_NAME="${APP_NAME} installer"
BGIMGFILE="macos/installer-background.png"
DMG_FILE_NAME="${BASEDIR}${APP_NAME}.dmg"
SRC_APP_FILE_DIR="${BASEDIR}Build/Products/Release/${APP_NAME}.app"
VOLICON_FILE="${SRC_APP_FILE_DIR}/Contents/Resources/AppIcon.icns"

# Since create-dmg does not clobber, be sure to delete previous DMG
[[ -f "${DMG_FILE_NAME}" ]] && rm "${DMG_FILE_NAME}"

# Create the DMG
$CREATE_DMG \
    --volname "${VOLUME_NAME}" \
    --volicon "${VOLICON_FILE}" \
    --background "${BGIMGFILE}" \
    --window-pos 200 120 \
    --window-size 800 400 \
    --icon-size 100 \
    --icon "${APP_NAME}.app" 200 210 \
    --hide-extension "${APP_NAME}.app" \
    --app-drop-link 600 200 \
    "${DMG_FILE_NAME}" \
    "${SRC_APP_FILE_DIR}"

ls -alh "${DMG_FILE_NAME}"
shasum -a 256 "${DMG_FILE_NAME}" >"${DMG_FILE_NAME}.checksum"
shasum --check "${DMG_FILE_NAME}.checksum"
