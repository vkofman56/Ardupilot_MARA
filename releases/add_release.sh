#!/bin/bash
# Script to add a new firmware release to the releases directory
# Usage: ./add_release.sh <board_name> <version> <firmware_directory>
# Example: ./add_release.sh "Kakute_H7_Mini" "v1.0.0" "../Kakute_H7_Mini"

set -e

if [ $# -lt 3 ]; then
    echo "Usage: $0 <board_name> <version> <firmware_directory>"
    echo ""
    echo "Example: $0 Kakute_H7_Mini v1.0.0 ../Kakute_H7_Mini"
    echo ""
    echo "This will:"
    echo "  1. Create releases/<board_name>/<version>/"
    echo "  2. Copy .apj and .bin files from firmware_directory"
    echo "  3. Create a RELEASE_NOTES.md template"
    exit 1
fi

BOARD_NAME="$1"
VERSION="$2"
FIRMWARE_DIR="$3"

RELEASE_DIR="$(dirname "$0")/${BOARD_NAME}/${VERSION}"

echo "Creating release directory: ${RELEASE_DIR}"
mkdir -p "${RELEASE_DIR}"

echo "Copying firmware files..."
if [ -f "${FIRMWARE_DIR}/arducopter.apj" ]; then
    cp "${FIRMWARE_DIR}/arducopter.apj" "${RELEASE_DIR}/"
    echo "  ✓ Copied arducopter.apj"
fi

if [ -f "${FIRMWARE_DIR}/arducopter.bin" ]; then
    cp "${FIRMWARE_DIR}/arducopter.bin" "${RELEASE_DIR}/"
    echo "  ✓ Copied arducopter.bin"
fi

if [ -f "${FIRMWARE_DIR}/arducopter_with_bl.hex" ]; then
    cp "${FIRMWARE_DIR}/arducopter_with_bl.hex" "${RELEASE_DIR}/"
    echo "  ✓ Copied arducopter_with_bl.hex"
fi

# Create RELEASE_NOTES.md template if it doesn't exist
if [ ! -f "${RELEASE_DIR}/RELEASE_NOTES.md" ]; then
    cat > "${RELEASE_DIR}/RELEASE_NOTES.md" <<EOF
# ${BOARD_NAME} - Release ${VERSION}

**Release Date**: $(date +%Y-%m-%d)
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: [TODO: Add board config name]

## What's Included

- \`arducopter.apj\` - For OTA updates via Mission Planner/QGroundControl
- \`arducopter.bin\` - For DFU mode flashing

## Board Specifications

[TODO: Add board specifications]
- **MCU**:
- **IMU**:
- **Barometer**:
- **Features**:

## Installation

### OTA Update (Recommended)
1. Connect FC to computer via USB
2. Open Mission Planner or QGroundControl
3. Navigate to firmware update section
4. Select "Load custom firmware"
5. Choose \`arducopter.apj\`

### DFU Mode (Initial Install)
1. Enter DFU mode (hold bootloader button while connecting USB)
2. Run: \`dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin\`

## Changelog

### ${VERSION} ($(date +%Y-%m-%d))
- [TODO: Add changelog items]
EOF
    echo "  ✓ Created RELEASE_NOTES.md template"
    echo ""
    echo "⚠️  Please edit ${RELEASE_DIR}/RELEASE_NOTES.md with specific details"
fi

echo ""
echo "✓ Release ${VERSION} for ${BOARD_NAME} created successfully!"
echo ""
echo "Files location: ${RELEASE_DIR}/"
ls -lh "${RELEASE_DIR}/"
