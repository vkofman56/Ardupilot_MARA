# TBS LUCID H7 Flight Controller - Release v1.0.0

**Release Date**: October 27, 2025
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: TBS_LUCID_H7
**Manufacturer**: [Team BlackSheep (TBS)](https://www.team-blacksheep.com/)

## What's Included

- `arducopter.apj` - For OTA updates via Mission Planner/QGroundControl
- `arducopter.bin` - For DFU mode flashing

## Board Specifications

- **MCU**: STM32H743 @ 480 MHz
- **IMU**: Dual ICM42688 (high-performance gyros)
- **Barometer**: DPS310 (precision barometer)
- **OSD**: AT7456E (built-in analog OSD)
- **Storage**: MicroSD card slot
- **USB**: USB-C connector
- **Bootloader Size**: 128 KB
- **PWM Outputs**: 13 total (12 motors + 1 LED)
- **UART Ports**: 7 configurable
- **CAN Bus**: Supported
- **Battery Input**: 2S-6S LiPo

## Power Outputs

- **3.3V Output**: 0.5A max
- **5V Output**: 3A max
- **9V Output**: 3A max (for HD VTX, GPIO controlled)
- **VSW**: Selectable 5V or VBAT (via board jumper, GPIO controlled on/off)

## Features

✅ Dual ICM42688 high-performance IMUs
✅ DPS310 precision barometer
✅ Built-in AT7456E OSD chip
✅ MicroSD card for logging
✅ Simultaneous analog and digital (DisplayPort) OSD
✅ USB-C connectivity
✅ CAN bus support
✅ 13 PWM/DShot outputs
✅ Bi-directional DShot on channels 1-10
✅ Dual switchable camera inputs (CAM1/CAM2)
✅ GPIO-controlled VTX and camera power
✅ 7 configurable UART ports with DMA
✅ Dual battery monitoring inputs
✅ Professional TBS quality and support

## UART Mapping

| Port | Function | DMA | Notes |
|------|----------|-----|-------|
| SERIAL0 | USB | - | MAVLink2 |
| SERIAL1 | UART1 | ✅ | RX1 is SBUS in HD VTX connector |
| SERIAL2 | UART2 | ✅ | GPS |
| SERIAL3 | UART3 | ✅ | DisplayPort (HD VTX) |
| SERIAL4 | UART4 | ✅ | MAVLink2, Telemetry 1 |
| SERIAL6 | UART6 | ✅ | RC Input (default) |
| SERIAL7 | UART7 | ✅ | MAVLink2, Telemetry 2 (with flow control) |
| SERIAL8 | UART8 | ✅ | ESC Telemetry (RX8 on ESC connector) |

## RC Input

RC input is configured by default via **USART6** (RX6 pin). Supports all serial RC protocols except PPM.

**Default**: `SERIAL6_PROTOCOL = 23`

**Connection Types**:
- **SBUS/DSM/SRXL**: Connect to RX6 pin
- **FPort**: Connect to TX6, set `SERIAL6_OPTIONS = 7` and `RSSI_TYPE = 3` (invert TX/RX, half duplex)
- **CRSF/ELRS**: Connect to both RX6 and TX6, set `RSSI_TYPE = 3` (provides telemetry automatically)

**Alternative**: If using SBUS on HD VTX connector (DJI TX), set `SERIAL1_PROTOCOL = 23` and change `SERIAL6_PROTOCOL` to something else.

## FrSky Telemetry

For FrSky S.PORT telemetry on UART1:
```
SERIAL1_PROTOCOL = 10
SERIAL1_OPTIONS = 7
```

## PWM Outputs

Total of **13 outputs** capable of PWM and DShot:

**Motor Groups**:
- **PWM 1-2**: Group1 - Bi-directional DShot capable
- **PWM 3-4**: Group2 - Bi-directional DShot capable
- **PWM 5-6**: Group3 - Bi-directional DShot capable
- **PWM 7-10**: Group4 - Bi-directional DShot capable
- **PWM 11-12**: Group5
- **PWM 13**: Group6 (LED strip)

**Important**:
- Channels within the same group must use the same output rate
- If any channel in a group uses DShot, all channels in that group must use DShot
- Channels 1-10 support bi-directional DShot

## OSD Support

The TBS LUCID H7 supports **dual OSD**:
1. **Analog OSD**: AT7456E chip (`OSD_TYPE = 1`)
2. **Digital OSD**: DisplayPort on UART3 (TX3/RX3 on HD VTX connector)

Both can be used **simultaneously**!

## Battery Monitoring

### Primary Battery Monitor

Built-in voltage sensor with external current sensor input. Supports up to **6S LiPo**, reads up to **130A**.

**Default Parameters**:
```
BATT_MONITOR = 4
BATT_VOLT_PIN = 10
BATT_CURR_PIN = 11
BATT_VOLT_MULT = 11.0
BATT_AMP_PERVLT = 40
```

### Secondary Battery Monitor

Pads for second analog battery monitor:
```
BATT2_MONITOR = 4
BATT2_VOLT_PIN = 18
BATT2_CURR_PIN = 7
BATT2_VOLT_MULT = 11.0
BATT2_AMP_PERVLT = [as required for your sensor]
```

## Analog Inputs

- **Analog RSSI**: `RSSI_PIN = 8`
- **Analog Airspeed**: `ARSPD_PIN = 4`

## Compass

The TBS LUCID H7 **does not have a built-in compass**. Connect an external compass via I2C on SDA/SCL pads.

## GPIO Power Controls

The TBS LUCID H7 has sophisticated GPIO-controlled power management:

### GPIO 81 - VSW Power Control
Controls VSW pins which output either VBAT or 5V (set via board jumper).
- **Default**: RELAY2 controls this GPIO (low by default = OFF)
- Setting GPIO low = removes power
- Used for analog VTX power

### GPIO 83 - VTX BEC Control
Controls 9V BEC output on HD VTX connector.
- **Default**: RELAY4 controls this GPIO (high by default = ON)
- Setting GPIO low = removes 9V power
- Used for HD VTX power management

### GPIO 82 - Camera Switcher
Switches between CAM1 and CAM2 video inputs.
- **Default**: RELAY3 controls this GPIO (high by default = CAM1)
- Setting GPIO low = switches to CAM2
- Used for dual camera setups

## Installation

### OTA Update (Recommended)
1. Connect FC to computer via USB-C
2. Open Mission Planner or QGroundControl
3. Navigate to firmware update section
4. Select "Load custom firmware"
5. Choose `arducopter.apj`
6. Wait for upload and automatic reboot

### DFU Mode (Initial Install/Recovery)
1. Disconnect USB
2. Press and hold bootloader button
3. Connect USB-C while holding button
4. Release after 2-3 seconds
5. Verify DFU mode: `lsusb | grep STM32` or `dfu-util -l`
6. Flash: `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin`
7. Disconnect and reconnect USB

**Recommended**: Use "with_bl.hex" file for initial DFU flashing if available.

## First-Time Setup Checklist

- [ ] Flash firmware via OTA or DFU
- [ ] Insert MicroSD card for logging
- [ ] Connect to Mission Planner/QGroundControl
- [ ] Perform accelerometer calibration
- [ ] Perform compass calibration (external compass required)
- [ ] Configure RC input (USART6 by default)
- [ ] Set up failsafe parameters
- [ ] Calibrate ESCs
- [ ] Configure flight modes
- [ ] Set up battery monitoring parameters
- [ ] Configure OSD (analog and/or digital)
- [ ] Set up camera switching if using dual cameras
- [ ] Test motors (with props removed!)
- [ ] Configure HD VTX on UART3 if using DJI/HD system
- [ ] Test GPIO power controls (VTX, camera switcher)

## Known Issues

None reported for this release.

## Compatibility

- ✅ TBS LUCID H7 Flight Controller
- ✅ 2S - 6S battery systems
- ✅ DJI HD VTX systems (with DisplayPort)
- ✅ Analog VTX systems
- ✅ Dual camera setups
- ✅ All standard RC protocols (except PPM)

## TBS Quality Notes

The TBS LUCID H7 is a professional-grade flight controller from Team BlackSheep, known for:
- High-quality components and construction
- Dual ICM42688 IMUs for redundancy and precision
- Comprehensive features for FPV racing and freestyle
- Excellent integration with TBS ecosystem
- Professional support from TBS
- Innovative features like dual OSD and camera switching

## Support

- **Team BlackSheep**: https://www.team-blacksheep.com/
- **TBS Forums**: https://www.team-blacksheep.com/forum/
- **ArduPilot Documentation**: https://ardupilot.org/
- **ArduPilot Forum**: https://discuss.ardupilot.org/
- **GitHub Issues**: https://github.com/vkofman56/Ardupilot_MARA/issues

## Advanced Features

### Dual Camera Setup
1. Connect cameras to CAM1 and CAM2 inputs
2. Set GPIO 82 via RELAY3 to switch between cameras
3. Can be controlled via RC switch or mission commands

### Power Management
- Use GPIO controls to manage VTX and camera power
- Useful for battery conservation and thermal management
- Can be automated via scripting or mission commands

### Dual Battery Monitoring
- Monitor two independent battery packs
- Useful for redundant power systems
- Each battery can have independent failsafe settings

## Changelog

### v1.0.0 (2025-10-27)
- Initial release
- Based on ArduPilot 4.7.0-dev master branch
- TBS_LUCID_H7 board configuration
- Custom arming delay (0 seconds)
- Full feature set enabled
- Dual IMU configuration
- Dual OSD support (analog + digital)
- GPIO power management
- Dual battery monitoring
- Camera switching support
