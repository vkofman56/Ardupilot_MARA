# Firmware Releases

This directory contains pre-built firmware releases for various flight controllers in the MARA project.

## Available Boards

### Goku H743 Pro Mini
- **Latest Version**: v1.0.0
- **Location**: `Goku_H743_Pro_Mini/v1.0.0/`
- **Firmware Type**: ArduCopter
- **Configuration**: FlywooH743Pro

### Kakute H7 Mini
- **Location**: `Kakute_H7_Mini/`
- **Firmware Type**: ArduCopter

### TMotor H7 Mini
- **Location**: `TMotor_H7_Mini/`
- **Firmware Type**: ArduCopter

## Directory Structure

```
releases/
├── README.md (this file)
├── Goku_H743_Pro_Mini/
│   ├── v1.0.0/
│   │   ├── arducopter.apj
│   │   ├── arducopter.bin
│   │   └── RELEASE_NOTES.md
│   └── latest -> v1.0.0
├── Kakute_H7_Mini/
│   └── v1.0.0/
│       ├── arducopter.apj
│       └── arducopter.bin
└── TMotor_H7_Mini/
    └── v1.0.0/
        ├── arducopter.apj
        └── arducopter.bin
```

## File Types

- **`.apj`** - ArduPilot firmware file for OTA updates via Mission Planner/QGroundControl
- **`.bin`** - Raw binary for DFU mode flashing or bootloader updates
- **`.hex`** - Intel HEX format (includes bootloader, used for recovery)

## Installation

### Method 1: OTA Update (Mission Planner/QGroundControl)
1. Download the `.apj` file for your board
2. Connect flight controller via USB
3. Open Mission Planner or QGroundControl
4. Go to firmware section → Load custom firmware
5. Select the downloaded `.apj` file

### Method 2: DFU Mode
1. Download the `.bin` file for your board
2. Enter DFU mode (hold bootloader button while connecting USB)
3. Flash with: `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D <filename>.bin`

## Release Naming Convention

Versions follow semantic versioning: `vMAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible changes or major features
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes, backward compatible

## Notes

- Always backup your parameters before flashing new firmware
- Perform accelerometer and compass calibration after major updates
- Check release notes for breaking changes
