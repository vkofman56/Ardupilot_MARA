# Quick Reference - Kakute H7 Mini Dual Board Support

## 🚀 Build Commands

### For v1.5 Boards (MPU6000 + Regular Flash):
```bash
cd Kakute_H7_Mini/
./build_custom_kakuteh7mini.sh
```

### For v1.3 Boards (BMI270 + NAND Flash):
```bash
cd Kakute_H7_Mini/
./build_custom_kakuteh7mini_nand.sh
```

## 📁 Firmware Locations

- **v1.5:** `build/KakuteH7Mini/bin/arducopter.apj`
- **v1.3:** `build/KakuteH7Mini-Nand/bin/arducopter.apj`

## 🔍 Board Identification

| Version | IMU | Flash | Build Script |
|---------|-----|-------|--------------|
| v1.5 | MPU6000 | 128Mbits regular | `build_custom_kakuteh7mini.sh` |
| v1.3 | BMI270 | 1GBit NAND | `build_custom_kakuteh7mini_nand.sh` |

## 📖 Documentation Files

- **`README_Board_Versions.md`** - Detailed identification guide
- **`PROJECT_NOTES.md`** - Complete project documentation
- **`arming_optimization_recommendations.md`** - Technical optimization details

## ⚡ Key Features

- ✅ **0-second arming delay** (both versions)
- ✅ **Full ArduCopter functionality**
- ✅ **Board-specific sensor support**
- ✅ **Automated build scripts**

---
*Quick reference for MARA project - October 23, 2024*