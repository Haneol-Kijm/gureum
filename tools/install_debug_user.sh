#!/bin/bash
set -o pipefail

run_with_echo() {
    echo "$@" && "$@" || exit $?
}

SCRIPT_DIR="$(dirname "$0")"
# shellcheck source=tools/ready.sh
. "${SCRIPT_DIR}/ready.sh" || exit $?

if command -v xcpretty >/dev/null; then
    PRINTER="xcpretty"
else
    PRINTER="cat"
fi

(xcodebuild -project 'Gureum.xcodeproj' -scheme 'OSX' -configuration "${CONFIGURATION}" | $PRINTER) || exit $?
if [ ! "${TARGET_BUILD_DIR}" ] || [ ! "${PRODUCT_NAME}" ]; then
    echo "something wrong" && exit 255
fi

/usr/bin/codesign --force --sign - --entitlements "${CONFIGURATION_TEMP_DIR}/OSX.build/Gureum.app.xcent" --timestamp=none "${TARGET_BUILD_DIR}/Gureum.app"

USER_INSTALL_PATH="${HOME}/Library/Input Methods"
run_with_echo mkdir -p "${USER_INSTALL_PATH}"
run_with_echo rm -rf "${USER_INSTALL_PATH}/${PRODUCT_NAME}.app"
run_with_echo cp -R "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app" "${USER_INSTALL_PATH}/"
run_with_echo /System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister -f -R -trusted "${USER_INSTALL_PATH}/${PRODUCT_NAME}.app"
echo killall -15 "${PRODUCT_NAME}"
killall -15 "${PRODUCT_NAME}" 2>/dev/null || true
run_with_echo open "${USER_INSTALL_PATH}/${PRODUCT_NAME}.app"
