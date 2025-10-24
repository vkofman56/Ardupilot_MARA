# T-Motor H7 Mini Flight Controller - DFU Recovery Procedures Research

## Board Information

### Basic Specifications
- **Board Name:** T-Motor H7 Mini (also called T-Motor H7)
- **MCU:** STM32H743 (480 MHz, dual-core capable)
- **Board ID:** AP_HW_TMOTORH7 = 1138 (0x472 in decimal)
- **Flash Size:** 2048 KB
- **Bootloader Size:** 384 KB (0x60000 bytes)
- **Application Start:** 0x08060000 (384 KB offset)

### Key Hardware Pins (from hwdef.dat)

#### USB Interface
- PA11: OTG_FS_DM (USB Data Minus)
- PA12: OTG_FS_DP (USB Data Plus)

#### Debug/SWD Interface
- PA13: JTMS-SWDIO (SWD Data)
- PA14: JTCK-SWCLK (SWD Clock)

#### LED for Bootloader Indication
- PA8: LED_BOOTLOADER OUTPUT LOW (Active Low)

#### Bootloader Configuration
- NO explicit STAY_IN_BOOTLOADER pin defined in hwdef-bl.dat
- This means the bootloader will attempt to boot to main firmware if valid
- DFU entry is typically via USB with bootloader button (if implemented)

---

## DFU Mode Entry Procedure

### Standard Hardware Recovery (with physical access)

#### Method 1: Bootloader Button Press + USB
According to T-Motor H7 Mini README.md:

**Procedure:**
1. **Connect USB cable** to the board while holding the **bootloader button**
2. Keep the button pressed during USB connection
3. The bootloader should enumerate as a DFU device
4. Release the button once detected

**Tools to verify DFU detection:**
```bash
# Linux/Mac
lsusb | grep STM32
dfu-util -l

# Windows
Device Manager should show "STM32 Device in DFU Mode"
```

#### Method 2: STM32CubeProgrammer (Official Tool)
The official ST tool supports DFU recovery:
1. Download STM32CubeProgrammer from STMicroelectronics
2. Select USB interface
3. Should automatically detect board in DFU mode
4. Flash "with_bl.hex" or "with_bl.bin"

### STM32H743 DFU Mode Technical Details

#### DFU Entry Mechanisms

The STM32H743 has multiple ways to enter DFU mode:

1. **Hardware BOOT0 Pin (if exposed)**
   - Some boards expose BOOT0 (System Memory boot)
   - Setting BOOT0=1 at reset forces DFU entry
   - T-Motor H7 Mini: **Not exposed on standard pinout**

2. **Bootloader Command**
   - Via CAN/UART/USB during bootloader phase
   - Specific timeout: 5 seconds (HAL_BOOTLOADER_TIMEOUT)

3. **RTC Register Magic Values**
   - The ArduPilot bootloader uses RTC registers to store boot mode
   - RTC_BOOT_HOLD = 0 forces bootloader wait
   - RTC_BOOT_FAST = fast boot to firmware
   - Cleared on normal boot

#### Bootloader Timeout
- **Default:** 5000 ms (5 seconds)
- During this time, the bootloader waits for firmware upload
- If no valid firmware is found, it stays in bootloader

---

## Firmware Files

### File Types and Locations

1. **Bootloader Binary**
   - Location: `/Tools/bootloaders/TMotorH743_bl.bin`
   - Format: RAW binary (384 KB)
   - Start Address: 0x08000000
   - Used for bootloader recovery

2. **Bootloader Hex**
   - Location: `/Tools/bootloaders/TMotorH743_bl.hex`
   - Format: Intel Hex (text)
   - Same binary, human-readable format

3. **Application Firmware**
   - Format: ArduPilot .apj files (standard OTA updates)
   - OR: "with_bl.hex" for full image including bootloader
   - Start Address: 0x08060000 (after bootloader)

### Firmware Image Structure

For T-Motor H7 Mini:
```
Flash Memory Layout:
0x08000000 - 0x08060000: Bootloader (384 KB)
0x08060000 - 0x20000000: Application (1664 KB available)
```

---

## DFU Recovery Tools

### Command-Line Tools

#### dfu-util (Cross-platform)
```bash
# List DFU devices
dfu-util -l

# Flash bootloader (reset after)
dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D TMotorH743_bl.bin

# Flash firmware with bootloader
dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D TMotorH743_with_bl.hex
```

**Note:** 
- VID:PID for STM32 DFU is 0483:df11
- The 0x08000000 address is important - it's the flash start

#### STM32CubeProgrammer (GUI)
- Official ST tool with graphical interface
- Supports DFU, UART, SWD, JTAG
- Best for GUI-based recovery
- Available on Windows, Linux, Mac

#### pyDFU (Python-based)
- Cross-platform Python implementation
- Useful for scripting
- More portable than dfu-util on some systems

### Ground Station Tools

#### Mission Planner / QGroundControl
- Can load firmware via UART/USB
- BUT requires bootloader to be working
- Won't help if bootloader is corrupted

#### ArduPilot MAVProxy
- Command-line GCS alternative
- Similar limitations as MP/QGC

---

## Comparison with Other H743 Boards

### Similar STM32H743 Boards

All these boards share similar DFU recovery procedures:

1. **KakuteH7** (Holybro) - Board ID 1048
   - Bootloader: 128 KB (vs T-Motor's 384 KB)
   - Same DFU entry: bootloader button + USB
   - README confirms: "DFU by plugging in USB with bootloader button pressed"

2. **Skystars H7HD** - Board ID 1075
   - Bootloader: 128 KB
   - DFU procedure: bootloader button + USB
   - Has VTX power-up pin setup in bootloader

3. **Matek H743** - Board ID 1013
   - Bootloader: 128 KB
   - Standard DFU entry
   
4. **PixFlamingoH743I** - Board ID 1132
   - Standard H743 DFU procedure

### Key Difference
**T-Motor H7 Mini uses larger bootloader (384 KB vs typical 128 KB)**

This might indicate:
- More features in bootloader (possibly network-based loading)
- Additional safety features
- Or simply reserved space for future functionality

---

## Firmware Compatibility Issues

### Potential Issues with T-Motor H7 Mini

#### 1. Bootloader Version Mismatch
- **Problem:** Firmware might expect newer/older bootloader
- **Solution:** Flash "with_bl.hex" instead of just .apj file
- **Signs:** Board won't boot or shows LED errors

#### 2. External Flash Configuration
- T-Motor H7 Mini has: 128 Mbits (16 MB) onboard flash
- Defined as: `ONBOARD_FLASH` in hwdef
- **Potential Issue:** Firmware may be built without flash support
- **Fix:** Build firmware specifically for TMotorH743 board

#### 3. RTC/Persistence Issues
- **Problem:** Bad RTC data prevents bootloader entry
- **Cause:** Corrupted firmware attempting RTC writes
- **Recovery:** DFU mode forces fresh RTC init
- **Prevention:** Never interrupt flashing process

#### 4. HAL_ENABLE_DFU_BOOT Setting
From hwdef.h: `#define HAL_ENABLE_DFU_BOOT FALSE`
- **Meaning:** Can't reboot to DFU from running firmware
- **Implication:** Must use hardware bootloader button method
- **Other boards:** Some enable this for software DFU triggering

#### 5. AP_BOOTLOADER_FLASHING_ENABLED Setting
From hwdef.h: `#define AP_BOOTLOADER_FLASHING_ENABLED 1`
- **Enabled:** Bootloader binary is included in ROMFS
- **Allows:** Updating bootloader via MAV_CMD_FLASH_BOOTLOADER
- **Magic Value:** 290876 (0x469EC)

---

## DFU Mode Recovery Step-by-Step

### Complete Recovery Procedure

#### Prerequisites
- USB cable
- Computer with USB drivers
- dfu-util OR STM32CubeProgrammer installed
- TMotorH743_bl.hex or TMotorH743_with_bl.hex firmware

#### Steps

1. **Identify the Bootloader Button**
   - On T-Motor H7 Mini, typically labeled "BOOT" or "BL"
   - Usually a small tactile button near USB connector
   - May be recessed or require pin press

2. **Connect Board to Computer**
   ```
   Do NOT plug in battery or power
   ```

3. **Enter DFU Mode**
   ```bash
   # Hold bootloader button
   # Connect USB cable
   # Board should enumerate as DFU device within 2 seconds
   # Release bootloader button
   ```

4. **Verify DFU Detection**
   ```bash
   dfu-util -l
   # Should output:
   # Bus 001 Device 020: ID 0483:df11 STMicroelectronics STM Device in DFU Mode
   ```

5. **Flash Bootloader + Firmware**
   ```bash
   # Option A: Flash with_bl.hex (includes bootloader + firmware)
   dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D TMotorH743_with_bl.hex
   
   # Option B: Flash just bootloader, then firmware
   dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D TMotorH743_bl.bin
   # (Then flash firmware via bootloader or ground station)
   ```

6. **Wait for Completion**
   - Don't disconnect USB during flashing
   - Progress will be shown in terminal
   - Typical time: 30-60 seconds

7. **Verify Flash**
   ```bash
   # Device should disconnect after successful flash
   # LED should indicate bootloader activity
   # Board should attempt to boot main firmware
   ```

8. **Connect Power**
   - Once DFU transfer complete
   - Battery/power connection
   - Board should boot normally

---

## Troubleshooting

### Problem: Board won't enter DFU mode

**Possible Causes:**
1. Wrong bootloader button (try all buttons)
2. Button contacts are dirty or broken
3. USB cable not properly inserted
4. PC USB port is unpowered
5. Corrupted bootloader (boot from ROM required)

**Solutions:**
- Try different USB ports
- Clean button contacts
- Use known-good USB cable
- Verify USB driver installed (Windows may need STM32 driver)
- If available: Use J-Link/ST-Link SWD probe to recover

### Problem: DFU device detected but flash fails

**Possible Causes:**
1. Wrong firmware file (not for H743)
2. Bad USB connection (intermittent)
3. Firmware flash address wrong
4. Device reset during programming

**Solutions:**
- Verify file: `file TMotorH743_with_bl.hex`
- Use `-D` flag for hex auto-detection
- Try lower flash speed if available
- Re-attempt with fresh firmware download

### Problem: Board boots but immediately reboots

**Possible Causes:**
1. Firmware for different board (wrong APJ_BOARD_ID)
2. Corrupted firmware CRC
3. Missing required peripherals (compass, baro)
4. Frequency/clock mismatch

**Solutions:**
- Flash again with `with_bl.hex` to reset
- Check firmware is for TMotorH743 (ID 1138)
- Check that compass/baro aren't required by default

### Problem: LED doesn't light during bootloader

**Possible Causes:**
1. LED pin burned out (PA8)
2. LED polarity reversed in firmware
3. Bootloader LED not enabled in this build
4. Normal behavior (some builds don't enable LED)

**Solutions:**
- Try uploading firmware (LED won't light during normal boot)
- Verify board with known-good firmware
- Not a critical failure if other functions work

---

## Advanced Recovery: SWD/JTAG

If USB DFU completely fails (very rare):

### Requirements
- ST-Link v2 or J-Link probe
- SWD cable
- OpenOCD or JLinkGDBServer
- GDB debugger

### SWD Pins on T-Motor H7 Mini
- PA13: SWDIO
- PA14: SWCLK
- GND: Any ground pad

### Flash via SWD
```bash
# Using OpenOCD
openocd -f interface/stlink-v2.cfg \
        -f target/stm32h7x.cfg \
        -c "init; flash write_image erase TMotorH743_bl.bin 0x08000000; shutdown"
```

---

## Official Documentation References

### From Ardupilot Codebase
- Bootloader source: `/Tools/AP_Bootloader/`
- Hardware definition: `/libraries/AP_HAL_ChibiOS/hwdef/TMotorH743/`
- Board types: `/Tools/AP_Bootloader/board_types.txt` (Line 263)

### ST Microelectronics
- STM32H743 Reference Manual: RM0433
- STM32H743 Datasheet: DS10693
- Section on System Memory DFU bootloader

### Tools
- dfu-util: http://dfu-util.sourceforge.net/
- STM32CubeProgrammer: https://www.st.com/en/development-tools/stm32cubeprog.html

---

## Summary

### Quick Reference

| Item | Value |
|------|-------|
| Board ID | 1138 (0x472) |
| MCU | STM32H743 |
| Flash Size | 2048 KB |
| Bootloader Size | 384 KB |
| App Start Address | 0x08060000 |
| DFU VID:PID | 0483:df11 |
| Bootloader Timeout | 5 seconds |
| USB Ports | PA11/PA12 (OTG FS) |
| SWD Pins | PA13/PA14 |

### Standard Recovery Command
```bash
# 1. Hold bootloader button and connect USB
# 2. Verify DFU mode: dfu-util -l
# 3. Flash firmware:
dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D TMotorH743_with_bl.hex
```

