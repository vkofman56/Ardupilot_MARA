# Firmware Releases

This directory contains pre-built firmware releases for various flight controllers in the MARA project.

## Available Boards

### Goku H743 Pro Mini
- **Latest Version**: v1.0.0
- **Location**: `Goku_H743_Pro_Mini/v1.0.0/`
- **Firmware Type**: ArduCopter
- **Configuration**: FlywooH743Pro
- **MCU**: STM32H743VIH6 @ 480 MHz

### Kakute H7 Mini
- **Latest Version**: v1.0.0
- **Location**: `Kakute_H7_Mini/v1.0.0/`
- **Firmware Type**: ArduCopter
- **Configuration**: KakuteH7Mini
- **MCU**: STM32H743VIT6 @ 480 MHz

### TMotor H7 Mini
- **Latest Version**: v1.0.0
- **Location**: `TMotor_H7_Mini/v1.0.0/`
- **Firmware Type**: ArduCopter
- **Configuration**: TMotorH743
- **MCU**: STM32H743VIT6 @ 480 MHz

### ARK FPV
- **Latest Version**: v1.0.0
- **Location**: `ARK_FPV/v1.0.0/`
- **Firmware Type**: ArduCopter
- **Configuration**: ARK_FPV
- **MCU**: STM32H743 @ 480 MHz
- **Manufacturer**: ARK Electronics

### TBS LUCID H7
- **Latest Version**: v1.0.0
- **Location**: `TBS_LUCID_H7/v1.0.0/`
- **Firmware Type**: ArduCopter
- **Configuration**: TBS_LUCID_H7
- **MCU**: STM32H743 @ 480 MHz
- **Manufacturer**: Team BlackSheep

## Directory Structure

```
releases/
├── README.md (this file)
├── add_release.sh (helper script)
├── Goku_H743_Pro_Mini/
│   └── v1.0.0/
│       ├── arducopter.apj
│       ├── arducopter.bin
│       └── RELEASE_NOTES.md
├── Kakute_H7_Mini/
│   └── v1.0.0/
│       ├── arducopter.apj
│       ├── arducopter.bin
│       └── RELEASE_NOTES.md
├── TMotor_H7_Mini/
│   └── v1.0.0/
│       ├── arducopter.apj
│       ├── arducopter.bin
│       └── RELEASE_NOTES.md
├── ARK_FPV/
│   └── v1.0.0/
│       ├── arducopter.apj
│       ├── arducopter.bin
│       └── RELEASE_NOTES.md
└── TBS_LUCID_H7/
    └── v1.0.0/
        ├── arducopter.apj
        ├── arducopter.bin
        └── RELEASE_NOTES.md
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
