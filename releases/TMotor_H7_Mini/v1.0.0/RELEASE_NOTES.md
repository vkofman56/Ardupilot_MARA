# T-Motor H7 Mini - Release v1.0.0

**Release Date**: October 27, 2025
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: TMotorH743

## What's Included

- `arducopter.apj` - For OTA updates via Mission Planner/QGroundControl
- `arducopter.bin` - For DFU mode flashing

## Board Specifications

- **MCU**: STM32H743VIT6 @ 480 MHz
- **Board ID**: 1138
- **IMU**: ICM42688 / BMI270 (depending on variant)
- **Barometer**: DPS310
- **OSD**: AT7456E (built-in)
- **Flash**: 128Mbits onboard flash (NO SD card)
- **USB**: USB-C connector
- **Bootloader Size**: 384 KB (larger than most boards)
- **PWM Outputs**: 5 (4 motor + 1 LED)
- **Brand**: T-Motor (high quality components)

## Important Notes

⚠️ **T-Motor H7 Mini has a unique 384KB bootloader** (3x larger than typical boards)
- This is a T-Motor design choice, possibly for future features
- Different from other H743 boards that use 128KB bootloaders

## Features

✅ ICM42688/BMI270 high-performance IMU
✅ DPS310 precision barometer
✅ Built-in OSD (AT7456E)
✅ USB-C connectivity
✅ Onboard flash storage (NO SD card needed)
✅ DShot support on all motor outputs
✅ Custom arming delay (0 seconds)
✅ High-quality T-Motor components

## UART Mapping

The T-Motor H7 Mini provides multiple UART ports:

| Port | Common Use | Notes |
|------|-----------|-------|
| USB | MAVLink/Console | - |
| UART1 | ESC Telemetry | DMA-enabled |
| UART3 | GPS | DMA-enabled |
| UART4 | User | - |
| UART5 | RC Input | DMA-enabled |
| UART6 | User | - |
| UART7 | User | DMA-enabled |

## PWM Outputs

- **4 Motor Outputs**: Full DShot support on all channels
- **1 LED Output**: For LED strip control
- All motor outputs support bi-directional DShot

## Battery Monitoring

Built-in high-precision voltage and current sensing. The T-Motor board is known for accurate battery monitoring.

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
4. Hold for 2-3 seconds, then release
5. Verify DFU mode: `lsusb | grep STM32` or `dfu-util -l`
6. Flash: `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin`
7. Disconnect and reconnect USB

**Note**: Due to the 384KB bootloader, the flash memory layout is different from other boards. Always use firmware specifically built for TMotorH743.

## DFU Recovery

The T-Motor H7 Mini has a **5-second bootloader timeout**. If you have issues entering DFU mode:

1. Try holding the bootloader button longer (5+ seconds)
2. Try different USB ports (USB 2.0 ports work better)
3. Use a high-quality USB cable
4. Check USB drivers on your computer

See the included `TMotor_H7_Mini_Recovery_Guide.md` for detailed recovery instructions.

## First-Time Setup Checklist

- [ ] Flash firmware via OTA or DFU
- [ ] Connect to Mission Planner/QGroundControl
- [ ] Perform accelerometer calibration
- [ ] Perform compass calibration (if using external compass)
- [ ] Configure RC input (UART5 by default)
- [ ] Set up failsafe parameters
- [ ] Calibrate ESCs
- [ ] Configure flight modes
- [ ] Set up battery monitoring parameters
- [ ] Test motors (with props removed!)
- [ ] Configure OSD if desired

## Known Issues

None reported for this release.

## Compatibility

- ✅ T-Motor H7 Mini (all variants)
- ❌ NOT compatible with other H743 boards (different bootloader size)

## T-Motor Quality Notes

The T-Motor H7 Mini is known for:
- High-quality components and construction
- Accurate sensor readings
- Reliable performance
- Good thermal management
- Professional-grade design

## Support

- ArduPilot Documentation: https://ardupilot.org/
- ArduPilot Forum: https://discuss.ardupilot.org/
- T-Motor Store: https://store.tmotor.com/
- GitHub Issues: https://github.com/vkofman56/Ardupilot_MARA/issues

## References

See also:
- `TMotor_H7_Mini_Quick_Reference.txt` - Quick reference card
- `TMotor_H7_Mini_Recovery_Guide.md` - Detailed recovery procedures
- `TMotor_H7_Mini_Research_Summary.txt` - Technical details

## Changelog

### v1.0.0 (2025-10-27)
- Initial release
- Based on ArduPilot 4.7.0-dev master branch
- TMotorH743 board configuration
- Custom arming delay (0 seconds)
- Full feature set enabled
- Optimized for T-Motor hardware
