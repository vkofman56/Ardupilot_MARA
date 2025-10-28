# ARK FPV Flight Controller - Release v1.0.0

**Release Date**: October 27, 2025
**ArduPilot Version**: 4.7.0-dev (master branch)
**Board Configuration**: ARK_FPV
**Manufacturer**: [ARK Electronics](https://arkelectron.com/)

## What's Included

- `arducopter.apj` - For OTA updates via Mission Planner/QGroundControl
- `arducopter.bin` - For DFU mode flashing

## Board Specifications

- **MCU**: STM32H743 @ 480 MHz
- **Flash**: 2MB
- **RAM**: 1MB
- **IMU**: Invensense IIM-42653 Industrial IMU (with heater resistor)
- **Barometer**: Bosch BMP390
- **Magnetometer**: ST IIS2MDC (built-in compass)
- **Storage**: MicroSD card slot
- **USB**: USB-C connector
- **Bootloader Size**: 128 KB
- **Power Input**: 5.5V - 54V (2S - 12S LiPo)
- **Dimensions**: 3.6 × 3.6 × 0.8 cm
- **Weight**: 7.5g with MicroSD card

## Power Outputs

- **12V Output**: 2A max
- **5V Output**: 2A max (300mA for main system, 200mA for IMU heater)

## Features

✅ Industrial-grade IIM-42653 IMU with heater
✅ Built-in compass (IIS2MDC magnetometer)
✅ High-precision BMP390 barometer
✅ MicroSD card for logging
✅ Wide voltage input (2S-12S)
✅ USB-C connectivity
✅ CAN bus support
✅ HD VTX support (DisplayPort)
✅ 9 PWM/DShot outputs
✅ Bi-directional DShot on motors 1-4
✅ Multiple regulated power outputs
✅ Professional-grade design by ARK Electronics

## UART Mapping

| Port | Function | DMA | Notes |
|------|----------|-----|-------|
| SERIAL0 | USB | - | Console/MAVLink |
| SERIAL1 | UART7 | ✅ | Telemetry (with flow control) |
| SERIAL2 | UART5 | ✅ | DisplayPort HD VTX |
| SERIAL3 | USART1 | ✅ | GPS (with I2C for compass) |
| SERIAL4 | USART2 | ❌ | User (SBUS pin on HD VTX, RX only) |
| SERIAL5 | UART4 | ✅ | ESC Telemetry (RX only) |
| SERIAL6 | USART6 | ✅ | RC Input |
| SERIAL7 | OTG2 | - | SLCAN |

All UARTs support DMA and can be re-tasked by changing protocol parameters.

## RC Input

RC input is configured on **USART6** (RX6 pin). Supports all serial RC protocols except PPM.

**Default**: `SERIAL6_PROTOCOL = 23`

**Connection Types**:
- **SBUS/DSM/SRXL**: Connect to RX6 pin
- **FPort**: Connect to TX6, set `SERIAL6_OPTIONS = 7` (invert TX/RX, half duplex)
- **CRSF/ELRS**: Connect to both RX6 and TX6, provides telemetry automatically, set `SERIAL6_OPTIONS = 3`
- **SRXL2**: Connect to TX6, provides telemetry, set `SERIAL6_OPTIONS = 4`

## PWM Outputs

Total of **9 outputs** capable of PWM and DShot:

**Motor Groups**:
- **Motors 1-4**: Group1 (TIM5) - Bi-directional DShot capable
- **Motors 5-8**: Group2 (TIM8) - DShot capable
- **Motor 9**: Group3 (TIM4) - DShot capable

**Important**: All outputs in the same group must use the same protocol (PWM or DShot).

## Connectors

### PWM UART4 - 8 Pin JST-GH
- VBAT IN (5.5V-54V)
- Current sensor input
- UART4 RX (ESC telemetry)
- Motors 1-4 (DShot/PWM)

### RC - 4 Pin JST-GH
- 5V output
- USART6 RX/TX (RC input)

### PWM AUX - 6 Pin JST-SH
- Motors 5-9 (DShot/PWM)

### POWER AUX - 3 Pin JST-GH
- 12V output (2A max)
- VBAT IN/OUT

### CAN - 4 Pin JST-GH
- 5V output
- CAN1_P / CAN1_N

### GPS - 6 Pin JST-GH
- 5V output
- USART1 TX/RX (GPS)
- I2C SCL/SDA (for external compass)

### TELEM - 6 Pin JST-GH
- 5V output
- UART7 with flow control (RTS/CTS)

### VTX - 6 Pin JST-GH
⚠️ **Note**: Connector pinout not in same order as standard HD VTX cabling
- 12V output
- UART5 TX/RX (DisplayPort)
- USART2 RX (SBUS)

### SPI (OSD or External IMU) - 8 Pin JST-SH
- 5V output
- SPI6 interface for external OSD or IMU

### DEBUG - 6 Pin JST-SH
- 3.3V output
- USART4 (debug console)
- SWD (SWDIO/SWCLK)

## Battery Monitoring

Built-in voltage sensor with external current sensor input. Supports up to **12S LiPo**.

**Default Parameters**:
```
BATT_MONITOR = 4
BATT_VOLT_PIN = 9
BATT_CURR_PIN = 12
BATT_VOLT_SCALE = 21
BATT_AMP_PERVLT = 120
```

## Compass

This autopilot has a **built-in compass** (IIS2MDC magnetometer). External compass can also be connected via I2C on GPS port.

## OSD Support

MSP-DisplayPort output on 6-pin DJI-compatible JST-SH connector via UART5.

## IMU Heater

The IIM-42653 IMU includes an integrated heater resistor for temperature stabilization in extreme environments. The heater draws power from the 5V rail (up to 200mA allocated).

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
2. Press and hold BOOT button
3. Connect USB-C while holding button
4. Release after 2-3 seconds
5. Verify DFU mode: `lsusb | grep STM32` or `dfu-util -l`
6. Flash: `dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin`
7. Disconnect and reconnect USB

**Note**: Initial firmware load can also be done via SWD (ST-Link) to address 0x08000000.

## First-Time Setup Checklist

- [ ] Flash firmware via OTA or DFU
- [ ] Insert MicroSD card for logging
- [ ] Connect to Mission Planner/QGroundControl
- [ ] Perform accelerometer calibration
- [ ] Perform compass calibration (built-in + external if used)
- [ ] Configure RC input (USART6 by default)
- [ ] Set up failsafe parameters
- [ ] Calibrate ESCs
- [ ] Configure flight modes
- [ ] Set up battery monitoring parameters
- [ ] Enable dataflash logging to SD card
- [ ] Test motors (with props removed!)
- [ ] Configure HD VTX on UART5 if using DJI/HD system

## Known Issues

None reported for this release.

## Compatibility

- ✅ ARK FPV Flight Controller (all variants)
- ✅ 2S - 12S battery systems
- ✅ DJI HD VTX systems
- ✅ All standard RC protocols (except PPM)

## ARK Electronics Quality

The ARK FPV is a professional-grade flight controller featuring:
- Industrial IMU with thermal management
- High-quality components and construction
- Wide voltage input range (2S-12S)
- Comprehensive connectivity options
- Professional support from ARK Electronics

## Support

- **ARK Electronics**: https://arkelectron.com/
- **Product Page**: https://arkelectron.com/product/ark-fpv-flight-controller/
- **ArduPilot Documentation**: https://ardupilot.org/
- **ArduPilot Forum**: https://discuss.ardupilot.org/
- **GitHub Issues**: https://github.com/vkofman56/Ardupilot_MARA/issues

## Build Commands

To rebuild firmware from source:
```bash
# Build bootloader
./waf configure --board ARK_FPV --bootloader
./waf bootloader

# Build firmware
./waf configure --board ARK_FPV
./waf copter --upload
```

## Changelog

### v1.0.0 (2025-10-27)
- Initial release
- Based on ArduPilot 4.7.0-dev master branch
- ARK_FPV board configuration
- Custom arming delay (0 seconds)
- Full feature set enabled
- MicroSD logging support
- Built-in compass and heater-equipped IMU
