# Kakute H7 Mini Board Versions - Build Guide

## Overview

You have **two different hardware revisions** of the Kakute H7 Mini flight controller that require **different firmware builds**:

- **v1.5** (newer) → Use regular KakuteH7Mini configuration
- **v1.3** (older) → Use KakuteH7Mini-Nand configuration

## Quick Identification Guide

### How to Identify Your Board Version

1. **Check the PCB silkscreen** - Look for version markings on the board
2. **Check purchase date** - v1.5 is newer (2023+), v1.3 is older (2022-)
3. **Test with firmware** - If regular KakuteH7Mini firmware doesn't work, you likely have v1.3

### Hardware Differences

| Feature | v1.5 (Regular) | v1.3 (NAND) |
|---------|----------------|-------------|
| **IMU Sensor** | MPU6000 | BMI270 |
| **Flash Memory** | 128Mbits regular | 1GBit NAND |
| **Storage Driver** | dataflash | littlefs:w25nxx |
| **ArduPilot Config** | KakuteH7Mini | KakuteH7Mini-Nand |
| **Works with regular build?** | ✅ Yes | ❌ No |

## Build Instructions

### For Kakute H7 Mini v1.5 (Regular)
```bash
cd Kakute_H7_Mini/
./build_custom_kakuteh7mini.sh
```
**Output firmware:** `build/KakuteH7Mini/bin/arducopter.apj`

### For Kakute H7 Mini v1.3 (NAND)
```bash
cd Kakute_H7_Mini/
./build_custom_kakuteh7mini_nand.sh
```
**Output firmware:** `build/KakuteH7Mini-Nand/bin/arducopter.apj`

## Firmware Features

Both builds include the MARA optimizations:
- ✅ **0-second arming delay** (modified from 2.0s default)
- ✅ Custom build optimizations
- ✅ Full ArduCopter functionality

## Troubleshooting

### If Your Board Won't Work

1. **Try the other build script** - You might have the wrong version identified
2. **Check board silkscreen** for version markings
3. **Check IMU sensor** in Mission Planner:
   - If you see MPU6000 → Use regular build
   - If you see BMI270 → Use NAND build

### Common Symptoms

**v1.3 board with regular firmware:**
- ❌ Won't boot properly
- ❌ IMU not detected
- ❌ Flash storage errors

**v1.5 board with NAND firmware:**
- ❌ May boot but sensors won't work correctly
- ❌ Wrong IMU orientation

## Technical Details

### Hardware Definitions Used

**v1.5 Regular:**
```
./waf configure --board KakuteH7Mini
```
- Uses: `/libraries/AP_HAL_ChibiOS/hwdef/KakuteH7Mini/hwdef.dat`

**v1.3 NAND:**
```
./waf configure --board KakuteH7Mini-Nand
```
- Uses: `/libraries/AP_HAL_ChibiOS/hwdef/KakuteH7Mini-Nand/hwdef.dat`
- Inherits base config from regular variant
- Overrides IMU and flash settings

### Key Configuration Differences

**v1.3 NAND Config Changes:**
```
# Remove MPU6000, add BMI270
undef mpu6000
undef IMU
SPIDEV bmi270 SPI4 DEVID1 MPU6000_CS MODE3 1*MHZ 4*MHZ
IMU BMI270 SPI:bmi270 ROTATION_PITCH_180_YAW_90

# Change flash driver
undef DATAFLASH
DATAFLASH littlefs:w25nxx
```

## Board ID Information

Both variants use the **same Board ID: 1058** in the firmware, but different hardware configurations. This is why you need different builds even though they share the same ID.

## Support

If you're unsure which version you have:
1. Try the regular build first (`./build_custom_kakuteh7mini.sh`)
2. If it doesn't work, try the NAND build (`./build_custom_kakuteh7mini_nand.sh`)
3. Check Mission Planner for IMU sensor type after successful connection

---
*Last updated: October 23, 2024*
*MARA ArduPilot Project - Kakute H7 Mini Support*