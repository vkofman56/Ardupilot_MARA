# MARA Project Notes - Kakute H7 Mini Dual Board Support
**Date:** October 23, 2024
**Status:** ✅ COMPLETED - Both board versions working
**Issue:** Resolved hardware compatibility between v1.3 and v1.5 boards

---

## 🎯 Problem Summary
- **Had 2 Kakute H7 Mini boards:** v1.3 and v1.5
- **v1.5 worked** with existing firmware
- **v1.3 failed** to work with same firmware
- **Root cause:** Different hardware (IMU sensor + flash memory type)

## 🔧 Solution Implemented
Created **dual firmware support** for both board versions:

### Board Version Differences
| Feature | v1.5 (Working) | v1.3 (Fixed) |
|---------|----------------|--------------|
| **IMU** | MPU6000 | BMI270 |
| **Flash** | 128Mbits regular | 1GBit NAND |
| **Config** | KakuteH7Mini | KakuteH7Mini-Nand |
| **Build Script** | `build_custom_kakuteh7mini.sh` | `build_custom_kakuteh7mini_nand.sh` |

---

## 📁 Files Created/Modified

### ✅ New Files Created:
1. **`build_custom_kakuteh7mini_nand.sh`** - Build script for v1.3 boards
2. **`README_Board_Versions.md`** - Board identification and usage guide
3. **`PROJECT_NOTES.md`** - This file (project documentation)

### 📝 Files Updated:
1. **`build_custom_kakuteh7mini.sh`** - Updated for clarity (now explicitly for v1.5)
2. **`arming_optimization_recommendations.md`** - Updated to cover both versions

### 🏗️ Files NOT Modified (preserved):
- Original ArduPilot source code (unchanged)
- Existing v1.5 firmware builds (still valid)
- Hardware definition files (used as-is from ArduPilot)

---

## 🚀 Usage Instructions

### For v1.5 Boards (Regular):
```bash
cd Kakute_H7_Mini/
./build_custom_kakuteh7mini.sh
# Generates: build/KakuteH7Mini/bin/arducopter.apj
```

### For v1.3 Boards (NAND):
```bash
cd Kakute_H7_Mini/
./build_custom_kakuteh7mini_nand.sh
# Generates: build/KakuteH7Mini-Nand/bin/arducopter.apj
```

---

## 🔬 Technical Details

### ArduPilot Hardware Configurations Used:
- **v1.5:** `/libraries/AP_HAL_ChibiOS/hwdef/KakuteH7Mini/`
- **v1.3:** `/libraries/AP_HAL_ChibiOS/hwdef/KakuteH7Mini-Nand/`

### Key Differences in NAND Config:
```
# v1.3 configuration overrides:
undef mpu6000
undef IMU
SPIDEV bmi270 SPI4 DEVID1 MPU6000_CS MODE3 1*MHZ 4*MHZ
IMU BMI270 SPI:bmi270 ROTATION_PITCH_180_YAW_90

undef DATAFLASH
DATAFLASH littlefs:w25nxx
```

### Common Features (Both Versions):
- **Processor:** STM32H743VIT6 (480 MHz)
- **Board ID:** 1058 (same for both)
- **Barometer:** BMP280
- **OSD:** AT7456E
- **USB:** USB-C connector
- **PWM:** 9 outputs (8 motor + 1 LED)
- **MARA Optimization:** 0-second arming delay

---

## ✅ Current Status

### What's Working:
- ✅ **v1.5 board:** Works with regular firmware
- ✅ **v1.3 board:** Works with NAND firmware (FIXED!)
- ✅ **Both versions:** Include 0-second arming delay optimization
- ✅ **Build scripts:** Automated for both versions
- ✅ **Documentation:** Complete identification guide

### Firmware Locations:
- **v1.5 firmware:** `build/KakuteH7Mini/bin/arducopter.apj`
- **v1.3 firmware:** `build/KakuteH7Mini-Nand/bin/arducopter.apj`

---

## 🔄 Next Steps (if needed)

### Potential Future Work:
1. **Performance testing** - Compare both boards in flight
2. **Parameter optimization** - Fine-tune for specific use cases
3. **Additional delay reductions** - If 0-second arming isn't fast enough
4. **Custom parameter sets** - Board-specific default configurations

### If Issues Arise:
1. **Check board version** using `README_Board_Versions.md`
2. **Verify correct firmware** is being used for the board version
3. **Re-run build script** if firmware corruption suspected
4. **Check sensor detection** in Mission Planner diagnostics

---

## 🛠️ Build Environment

### Prerequisites:
- **Toolchain:** ARM GNU Toolchain 11.3.rel1
- **Python:** 3.14+ with empy, pexpect, future packages
- **Platform:** macOS (Darwin 24.6.0)
- **ArduPilot:** 4.7.0-dev

### Build Commands Reference:
```bash
# Set toolchain path
export PATH=/Applications/ArmGNUToolchain/11.3.rel1/arm-none-eabi/bin:$PATH

# Manual build for v1.5
cd ../ardupilot-4.7.0-dev
./waf configure --board KakuteH7Mini
./waf copter

# Manual build for v1.3
cd ../ardupilot-4.7.0-dev
./waf configure --board KakuteH7Mini-Nand
./waf copter
```

---

## 📞 Support Information

### Key Identifiers:
- **Project:** MARA ArduPilot Kakute H7 Mini Optimization
- **Boards:** Holybro Kakute H7 Mini v1.3 and v1.5
- **Issue Resolved:** Hardware compatibility between board revisions
- **Solution:** Dual firmware builds with proper hardware configurations

### Files to Reference:
- `README_Board_Versions.md` - Board identification
- `arming_optimization_recommendations.md` - Technical details
- Build scripts - Automated compilation

---

**🎉 Project Status: SUCCESSFUL - Both boards operational with optimized firmware**

*Last updated: October 23, 2024*
*All build artifacts generated and tested successfully*