# Flywoo H743 Pro Flight Controller - Release v1.0.0

**Release Date**: October 27, 2025
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: FlywooH743Pro
**Manufacturer**: [Flywoo](https://www.flywoo.net/)

## What's Included

- `arducopter.apj` - For OTA updates via Mission Planner/QGroundControl
- `arducopter.bin` - For DFU mode flashing

## Board Specifications

- **MCU**: STM32H743 @ 480 MHz
- **Board ID**: 1181
- **Flash**: 2048 KB total
  - Bootloader: 384 KB
  - Application: 1664 KB
- **IMU**: Dual ICM42688 (Invensense v3)
  - Both with ROTATION_PITCH_180_YAW_90
- **Barometer**: SPL06
- **OSD**: AT7456E (analog)
- **Onboard Flash**: 500 MB
- **USB**: USB connector
- **Bootloader Size**: 384 KB
- **PWM Outputs**: 13 (12 motors + 1 LED)
- **UART Ports**: 7 configurable
- **Battery**: 2S-6S LiPo support

## Power Outputs

- **3.3V**: 0.5A
- **5V**: 3A
- **10V**: 3A (for video, GPIO controlled)

## Features

✅ Dual ICM42688 high-performance IMUs
✅ SPL06 precision barometer
✅ Built-in AT7456E OSD chip
✅ 500MB onboard flash storage
✅ DisplayPort OSD support
✅ USB connectivity
✅ 13 PWM/DShot outputs
✅ Bi-directional DShot on channels 1-10
✅ Dual switchable camera inputs
✅ GPIO-controlled VTX power (10V output)
✅ 7 configurable UART ports with DMA
✅ Battery voltage and current sensing

## UART Mapping

| Port | Function | DMA | Notes |
|------|----------|-----|-------|
| SERIAL0 | USB | - | Console/MAVLink |
| SERIAL1 | UART1 | ✅ | User configurable |
| SERIAL2 | UART2 | ✅ | RC Receiver (default) |
| SERIAL3 | UART3 | ❌ | User configurable |
| SERIAL4 | UART4 | ✅ | GPS |
| SERIAL6 | UART6 | ❌ | ESC Telemetry |
| SERIAL7 | UART7 | ❌ | User configurable |
| SERIAL8 | UART8 | ✅ | DisplayPort/HD VTX |

## RC Input

RC input is configured by default via **UART2 RX** input. Supports all serial RC protocols except PPM.

**Connection Types**:
- **SBUS/DSM/SRXL**: Connect to RX2 pin
- **FPort**: Connect to UART2 TX pin, set `RSSI_TYPE = 3` and `SERIAL2_OPTIONS = 7` (invert TX/RX, half duplex)
- **CRSF/ELRS**: Use both RX1 and TX1, set `RSSI_TYPE = 3` for full duplex with telemetry

## FrSky Telemetry

For FrSky S.PORT telemetry, use an unused UART (e.g., UART3):
```
SERIAL3_PROTOCOL = 10
SERIAL3_OPTIONS = 7
```

## PWM Outputs

Total of **13 outputs** capable of PWM and DShot:

**Motor Groups**:
- **PWM 1-2**: Group1 - Bi-directional DShot capable
- **PWM 3-6**: Group2 - Bi-directional DShot capable
- **PWM 7-10**: Group3 - Bi-directional DShot capable
- **PWM 11-12**: Group4
- **PWM 13**: Group5 (LED strip)

**Important**:
- Channels within the same group must use the same output rate
- If any channel in a group uses DShot, all channels in that group must use DShot
- Channels 1-10 support bi-directional DShot

## OSD Support

The Flywoo H743 Pro supports **dual OSD**:
1. **Analog OSD**: AT7456E chip (`OSD_TYPE = 1`, MAX7456 driver)
2. **Digital OSD**: DisplayPort on UART8 (TX8/RX8 on HD VTX connector)

Both can be used **simultaneously**!

## Battery Monitoring

Built-in voltage sensor with external current sensor input. The current sensor can read up to **130 Amps**. Voltage sensor can handle up to **6S LiPo**.

**Default Parameters**:
```
BATT_MONITOR = 4
BATT_VOLT_PIN = 11
BATT_CURR_PIN = 13
BATT_VOLT_MULT = 11.1
BATT_AMP_PERVLT = 40
```

## Compass

The Flywoo H743 Pro **does not have a built-in compass**. Connect an external compass via I2C on SDA/SCL pads.

## VTX Power Control

**GPIO 81** controls the VTX BEC output to pins marked "10V".
- Setting GPIO low removes voltage supply to these pins
- By default, **RELAY2** is configured to control this GPIO and sets it high
- Useful for power management and thermal control

## Camera Control

**GPIO 82** controls the camera output to connectors marked "CAM1" and "CAM2".
- Setting GPIO low switches video output from CAM1 to CAM2
- By default, **RELAY3** is configured to control this GPIO and sets it high
- Enables dual camera switching for FPV applications

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

**Recommended**: Use "with_bl.hex" file for initial DFU flashing if available.

## First-Time Setup Checklist

- [ ] Flash firmware via OTA or DFU
- [ ] Connect to Mission Planner/QGroundControl
- [ ] Perform accelerometer calibration
- [ ] Perform compass calibration (external compass required)
- [ ] Configure RC input (UART2 by default)
- [ ] Set up failsafe parameters
- [ ] Calibrate ESCs
- [ ] Configure flight modes
- [ ] Set up battery monitoring parameters
- [ ] Configure OSD (analog and/or digital)
- [ ] Set up camera switching if using dual cameras
- [ ] Test motors (with props removed!)
- [ ] Configure HD VTX on UART8 if using DJI/HD system
- [ ] Test GPIO power controls (VTX power, camera switcher)

## Known Issues

None reported for this release.

## Compatibility

- ✅ Flywoo H743 Pro Flight Controller
- ✅ Compatible with Goku H743 Pro Mini (same board configuration)
- ✅ 2S - 6S battery systems
- ✅ DJI HD VTX systems (with DisplayPort)
- ✅ Analog VTX systems
- ✅ Dual camera setups
- ✅ All standard RC protocols (except PPM)

## Flywoo Quality Notes

The Flywoo H743 Pro is a high-performance flight controller featuring:
- Dual ICM42688 IMUs for redundancy and precision
- High-quality components and construction
- Comprehensive features for FPV racing and freestyle
- 500MB onboard flash for extensive logging
- Excellent value for performance
- Good support from Flywoo community

## Build Information

- **Flash Used**: 1,435,872 bytes (84.3% of available)
- **Free Flash**: 268,016 bytes
- **ArduPilot Version**: 4.7.0-dev (master branch)
- **Build Date**: October 27, 2025

## Support

- **Flywoo**: https://www.flywoo.net/
- **ArduPilot Documentation**: https://ardupilot.org/
- **ArduPilot Forum**: https://discuss.ardupilot.org/
- **GitHub Issues**: https://github.com/vkofman56/Ardupilot_MARA/issues

## Advanced Features

### Dual Camera Setup
1. Connect cameras to CAM1 and CAM2 inputs
2. Set GPIO 82 via RELAY3 to switch between cameras
3. Can be controlled via RC switch or mission commands

### Power Management
- Use GPIO 81 to control 10V VTX power
- Useful for battery conservation and thermal management
- Can be automated via scripting or mission commands

### Dual IMU Configuration
- Two ICM42688 IMUs provide redundancy
- ArduPilot automatically handles IMU failover
- Improved reliability and flight performance

## Notes

This board configuration is also used by:
- **Goku H743 Pro Mini** (hardware compatible)

Both boards share the same FlywooH743Pro configuration in ArduPilot.

## Build Commands

To rebuild firmware from source:
```bash
# Configure for FlywooH743Pro
./waf configure --board FlywooH743Pro

# Build ArduCopter
./waf copter

# Output location:
# build/FlywooH743Pro/bin/arducopter.apj
# build/FlywooH743Pro/bin/arducopter.bin
```

## Changelog

### v1.0.0 (2025-10-27)
- Initial release
- Based on ArduPilot 4.7.0-dev master branch
- FlywooH743Pro board configuration
- Dual IMU support (ICM42688)
- Full feature set enabled
- Onboard flash logging support
- Dual OSD support (analog + digital)
- GPIO power management
- Camera switching support
- Custom arming delay (0 seconds)
