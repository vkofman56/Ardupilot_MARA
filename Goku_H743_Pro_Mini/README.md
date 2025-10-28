# Goku H743 Pro Mini - ArduCopter Firmware

Custom ArduCopter firmware build for the **Goku H743 Pro Mini** flight controller.

## Hardware Specifications

- **MCU**: STM32H743VIH6 @ 480 MHz
- **IMU**: Dual ICM42688P gyroscopes
- **Barometer**: SPL06
- **OSD**: AT7456E
- **Flash Memory**: 500MB onboard
- **PWM Outputs**: 13 total (12 motors + 1 LED)
  - Channels 1-10 support bi-directional DShot
- **UART Ports**: 7 with predefined functions
- **Battery**: 2S-6S LiPo support
- **BEC**:
  - 3.3V @ 0.5A
  - 5V @ 3A
  - 10V @ 3A (for video, GPIO controlled)

## Board Configuration

This board uses the **FlywooH743Pro** configuration in ArduPilot, as it is hardware-compatible.

## UART Mapping

| Serial Port | Function | Notes |
|------------|----------|-------|
| SERIAL0 | USB | - |
| SERIAL1 | UART1 | User, DMA-enabled |
| SERIAL2 | UART2 | RC Receiver, DMA-enabled |
| SERIAL3 | UART3 | User |
| SERIAL4 | UART4 | GPS, DMA-enabled |
| SERIAL6 | UART6 | ESC Telemetry |
| SERIAL7 | UART7 | User |
| SERIAL8 | UART8 | DisplayPort/HD VTX, DMA-enabled |

## RC Input Configuration

RC input is configured by default via **UART2 RX**. Supports all serial RC protocols except PPM.

**Note**:
- For FPort receivers: Connect to UART2 TX pin, set `RSSI_TYPE = 3` and `SERIAL2_OPTIONS = 7` (invert TX/RX, half duplex)
- For CRSF/ELRS (full duplex): Use both RX1 and TX1, set `RSSI_TYPE = 3`

## PWM Output Groups

Channels within the same group must use the same output rate. If any channel in a group uses DShot, all channels in that group must use DShot.

- **Group 1**: PWM 1-2
- **Group 2**: PWM 3-6
- **Group 3**: PWM 7-10
- **Group 4**: PWM 11-12
- **Group 5**: PWM 13 (LED)

## Battery Monitoring

The board has built-in voltage and current sensing.

**Default Parameters**:
```
BATT_MONITOR = 4
BATT_VOLT_PIN = 11
BATT_CURR_PIN = 13
BATT_VOLT_MULT = 11.1
BATT_AMP_PERVLT = 40
```

Maximum current reading: 130A

## Firmware Files

| File | Purpose | Size |
|------|---------|------|
| `arducopter.apj` | OTA firmware updates via Mission Planner/QGroundControl | 1.3 MB |
| `arducopter.bin` | Raw binary (for advanced users) | 1.4 MB |
| `arducopter` | ELF executable (debug/analysis) | 2.9 MB |

## Installation Methods

### Method 1: OTA Update (Recommended)

If you already have ArduPilot firmware running on the board:

1. Connect the flight controller to your computer via USB
2. Open Mission Planner or QGroundControl
3. Go to firmware update section
4. Select "Custom Firmware" or "Load custom firmware"
5. Browse and select `arducopter.apj`
6. Wait for upload to complete
7. Board will automatically reboot with new firmware

### Method 2: DFU Mode (Initial Install)

For first-time installation or recovery:

1. **Enter DFU Mode**:
   - Disconnect USB from the board
   - Press and HOLD the bootloader button
   - While holding, connect USB to computer
   - Hold button for 2-3 seconds
   - Release button

2. **Verify DFU Mode**:
   ```bash
   # Linux/Mac
   lsusb | grep STM32
   # or
   dfu-util -l
   ```
   You should see "STMicroelectronics STM Device in DFU Mode"

3. **Flash Firmware**:
   ```bash
   dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D arducopter.bin
   ```

4. **Reboot**: Disconnect and reconnect USB

**Note**: For DFU flashing, you may need the bootloader combined image. If the above doesn't work, you may need to build with `--bootloader` flag or use the bootloader from `Tools/bootloaders/FlywooH743Pro_bl.bin`.

## Build Information

- **ArduPilot Version**: 4.7.0-dev (latest master)
- **Build Date**: October 27, 2025
- **Board ID**: 1181 (FlywooH743Pro)
- **Bootloader Size**: 384 KB
- **Flash Used**: 1,435,872 bytes (84% of available)
- **Free Flash**: 268,016 bytes

## OSD Support

The board supports:
- **Analog OSD**: Using AT7456E chip (`OSD_TYPE = 1`)
- **DisplayPort OSD**: Via UART8 (TX8/RX8) on HD VTX connector

Both can be used simultaneously.

## VTX and Camera Control

- **GPIO 81**: Controls VTX BEC output (10V pins). Set via RELAY2 (default high)
- **GPIO 82**: Camera switcher (CAM1/CAM2). Set via RELAY3 (default high, selects CAM1)

## External Compass

The board does not have a built-in compass. Connect an external compass via I2C (SDA/SCL pads).

## Rebuilding Firmware

To rebuild the firmware:

```bash
cd /home/user/Ardupilot_MARA
./Goku_H743_Pro_Mini/build_custom_goku_h743_pro_mini.sh
```

## Support and Documentation

- **ArduPilot Documentation**: https://ardupilot.org/
- **ArduPilot Forum**: https://discuss.ardupilot.org/
- **GitHub**: https://github.com/ArduPilot/ardupilot

## Important Notes

1. **First Flight**: Always perform accelerometer and compass calibration before first flight
2. **ESC Calibration**: May be required depending on your ESC type
3. **RC Calibration**: Required before first flight
4. **Parameter Tuning**: Default PIDs are conservative; tuning recommended for optimal performance
5. **Failsafe Setup**: Configure failsafe options before first flight

## Troubleshooting

### Board not detected
- Try different USB cable
- Check USB drivers
- Verify board has power
- Try DFU mode

### Cannot enter DFU mode
- Ensure you're pressing the correct bootloader button
- Try holding button longer (5+ seconds)
- Try different USB port
- May need to short BOOT0 to 3.3V manually

### Firmware upload fails
- Verify correct firmware file
- Check available flash space
- Try erasing flash first: `dfu-util -e`
- Use Mission Planner's "Load custom firmware" feature instead

## Version History

- **v1.0** (2025-10-27): Initial build based on ArduPilot 4.7.0-dev master branch
