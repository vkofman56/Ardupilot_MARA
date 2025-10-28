# Kakute H7 Mini v1.5 - Release v1.0.0

**Release Date**: October 27, 2025
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: KakuteH7Mini

## What's Included

- `arducopter.apj` - For OTA updates via Mission Planner/QGroundControl
- `arducopter.bin` - For DFU mode flashing

## Board Specifications

- **MCU**: STM32H743VIT6 @ 480 MHz
- **Board ID**: 1058
- **IMU**: MPU6000
- **Barometer**: BMP280
- **OSD**: AT7456E (built-in)
- **Flash**: 128Mbits onboard flash (NO SD card)
- **USB**: USB-C connector
- **Bootloader Size**: 128 KB
- **Storage**: LittleFS filesystem on internal flash

## Important Notes

⚠️ **This firmware is specifically for Kakute H7 Mini v1.5 boards!**
- Uses **MPU6000** IMU
- Uses **regular dataflash** storage driver
- For v1.3 boards (with NAND flash), use a different build variant

## Features

✅ MPU6000 IMU support
✅ Built-in OSD (AT7456E)
✅ BMP280 barometer
✅ USB-C connectivity
✅ LittleFS filesystem
✅ Onboard flash storage (NO SD card needed)
✅ DShot support
✅ Custom arming delay (0 seconds)

## UART Mapping

The Kakute H7 Mini has multiple UART ports for various peripherals:

| Port | Common Use | Notes |
|------|-----------|-------|
| USB | MAVLink/Console | - |
| UART1 | GPS | DMA-enabled |
| UART2 | RC Receiver | DMA-enabled |
| UART3 | Telemetry | User configurable |
| UART4 | User | DMA-enabled |
| UART6 | ESC Telemetry | - |
| UART7 | User | - |

## PWM Outputs

Supports multiple PWM/DShot outputs for motors and servos. DShot protocols are supported on motor outputs.

## Battery Monitoring

Built-in voltage and current sensing. Configure with appropriate scaling parameters for your setup.

## Installation

### OTA Update (Recommended)
1. Connect FC to computer via USB
2. Open Mission Planner or QGroundControl
3. Navigate to firmware update section
4. Select "Load custom firmware"
5. Choose `arducopter.apj`
6. Wait for upload and automatic reboot

### DFU Mode (Initial Install/Recovery)
1. Disconnect USB
2. Press and hold bootloader button
3. Connect USB while holding button
4. Release after 2-3 seconds
5. Run: `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin`
6. Disconnect and reconnect USB

## First-Time Setup Checklist

- [ ] Flash firmware via OTA or DFU
- [ ] Connect to Mission Planner/QGroundControl
- [ ] Perform accelerometer calibration
- [ ] Perform compass calibration (if using external compass)
- [ ] Configure RC input (UART2 by default)
- [ ] Set up failsafe parameters
- [ ] Calibrate ESCs if needed
- [ ] Configure flight modes
- [ ] Set up battery monitoring parameters
- [ ] Test motors (with props removed!)
- [ ] Configure OSD if desired

## Known Issues

None reported for this release.

## Compatibility

- ✅ Kakute H7 Mini v1.5 (MPU6000, regular flash)
- ❌ NOT compatible with v1.3 (different flash type)

## Support

- ArduPilot Documentation: https://ardupilot.org/
- ArduPilot Forum: https://discuss.ardupilot.org/
- GitHub Issues: https://github.com/vkofman56/Ardupilot_MARA/issues

## Changelog

### v1.0.0 (2025-10-27)
- Initial release
- Based on ArduPilot 4.7.0-dev master branch
- KakuteH7Mini board configuration
- Custom arming delay (0 seconds)
- Full feature set enabled
- Optimized for v1.5 hardware
