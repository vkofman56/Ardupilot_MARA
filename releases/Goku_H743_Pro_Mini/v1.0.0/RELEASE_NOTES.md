# Goku H743 Pro Mini - Release v1.0.0

**Release Date**: November 1, 2025
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: FlywooH743Pro
**Custom Modifications**: ARMING_DELAY_SEC = 0.0f (instant arming)

## What's Included

- `arducopter.apj` (1.3 MB) - For OTA updates via Mission Planner/QGroundControl
- `arducopter.bin` (1.4 MB) - For DFU mode flashing

## Board Specifications

- **MCU**: STM32H743VIH6 @ 480 MHz
- **IMU**: Dual ICM42688P gyroscopes
- **Barometer**: SPL06
- **OSD**: AT7456E (analog) + DisplayPort (digital)
- **Flash**: 512MB onboard (SDIO interface)
- **PWM Outputs**: 13 (12 motors + 1 LED, bi-directional DShot on 1-10)
- **UART Ports**: 7 with predefined functions
- **Battery**: 2S-6S LiPo support

## Features

✅ **Custom arming delay (0 seconds)** - Instant arming with no delay
✅ **512MB onboard flash logging** (SDIO interface, appears as SD card)
✅ Dual IMU redundancy
✅ Bi-directional DShot support
✅ OSD (analog and DisplayPort)
✅ 7 configurable UART ports
✅ GPS support (UART4)
✅ RC input via UART2
✅ ESC telemetry (UART6)
✅ External compass via I2C
✅ Battery voltage and current sensing

## ⚠️ IMPORTANT: Flash Logging Setup

The 512MB onboard flash uses **SDIO interface** and appears as an "SD card" to the firmware.

**The flash MUST be formatted as FAT32 (not FAT16) for ArduPilot logging to work.**

If you see "Logging: Error" in Mission Planner after flashing:

1. Flash Betaflight firmware temporarily
2. In Betaflight Configurator, go to **Blackbox** tab
3. Click **"Activate Mass Storage Device Mode"**
4. Format the drive as **FAT32**:
   - **macOS**: `sudo newfs_msdos -F 32 -v ARDUPILOT /dev/diskXs1`
   - **Windows**: Use FAT32 formatter (built-in format may use FAT16 for small drives)
   - **Linux**: `sudo mkfs.vfat -F 32 /dev/sdX1`
5. Eject the drive and power cycle the FC
6. Flash ArduPilot firmware again

**Note**: Betaflight formats the flash as FAT16 by default, which ArduPilot does not support for logging.

## Flash Usage

- **Used**: 1,435,872 bytes (84.3%)
- **Free**: 268,016 bytes (15.7%)

## Installation

### OTA Update (Recommended)
1. Connect FC to computer via USB
2. Open Mission Planner or QGroundControl
3. Navigate to firmware update section
4. Select "Load custom firmware"
5. Choose `arducopter.apj`
6. Wait for upload and automatic reboot

### DFU Mode (Initial Install)
1. Disconnect USB
2. Press and hold bootloader button
3. Connect USB while holding button
4. Release after 2-3 seconds
5. Run: `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin`
6. Disconnect and reconnect USB

## UART Configuration

| Port | Default Function | DMA | Notes |
|------|-----------------|-----|-------|
| SERIAL0 | USB | - | Console/MAVLink |
| SERIAL1 | UART1 | ✅ | User configurable |
| SERIAL2 | UART2 | ✅ | RC Receiver |
| SERIAL3 | UART3 | ❌ | User configurable |
| SERIAL4 | UART4 | ✅ | GPS |
| SERIAL6 | UART6 | ❌ | ESC Telemetry |
| SERIAL7 | UART7 | ❌ | User configurable |
| SERIAL8 | UART8 | ✅ | DisplayPort/HD VTX |

## Battery Monitoring

Default parameters for built-in voltage and current sensing:
```
BATT_MONITOR = 4
BATT_VOLT_PIN = 11
BATT_CURR_PIN = 13
BATT_VOLT_MULT = 11.1
BATT_AMP_PERVLT = 40
```

## First-Time Setup Checklist

- [ ] Format onboard flash as FAT32 (see instructions above)
- [ ] Flash firmware via OTA or DFU
- [ ] Connect to Mission Planner/QGroundControl
- [ ] Verify "Logging" shows "Normal" (not "Error")
- [ ] Perform accelerometer calibration
- [ ] Perform compass calibration (external compass)
- [ ] Configure RC input (SERIAL2)
- [ ] Set up failsafe parameters
- [ ] Calibrate ESCs if needed
- [ ] Configure flight modes
- [ ] Set up battery monitoring parameters
- [ ] Test motors (with props removed!)
- [ ] Configure OSD if desired

## Known Issues

- **Logging Error**: If "Logging: Error" appears, format flash as FAT32 (see instructions above)

## Compatibility

- ✅ Mission Planner (latest)
- ✅ QGroundControl (latest)
- ✅ MAVProxy
- ✅ All standard ArduCopter GCS software

## Support

- ArduPilot Documentation: https://ardupilot.org/
- ArduPilot Forum: https://discuss.ardupilot.org/
- GitHub Issues: https://github.com/vkofman56/Ardupilot_MARA/issues

## Build Information

- **Build Date**: 2025-11-01
- **Toolchain**: gcc-arm-none-eabi 13.2.1
- **Python**: 3.11.14
- **Build Time**: ~3 minutes
- **Modifications**: ArduCopter/config.h - ARMING_DELAY_SEC changed from 2.0f to 0.0f

## Changelog

### v1.0.0 (2025-12-01) - Updated
- **Added FAT32 formatting instructions** for onboard flash logging
- **Clarified**: Flash uses SDIO interface (512MB, appears as SD card)
- Modified arming delay from 2.0 seconds to 0 seconds for instant arming
- Based on ArduPilot 4.7.0-dev master branch
- FlywooH743Pro board configuration

### v1.0.0 (2025-11-01) - Initial
- Initial release with 0-second arming delay
- Standard ArduPilot configuration
