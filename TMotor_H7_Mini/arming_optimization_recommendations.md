# ArduPilot Arming Optimization Recommendations - T-Motor H7 Mini

## Current Status ✅
- **ARMING_DELAY_SEC** modified from `2.0f` to `0.0f` in `config.h:45`
- Custom firmware compiled for:
  - **T-Motor H7 Mini** (Board ID 1138): `../ardupilot-4.7.0-dev/build/TMotorH743/bin/arducopter.apj`

## Board Information
- **Board Name:** TMotorH743
- **Board ID:** 1138
- **Processor:** STM32H743VIT6
- **Hardware Definition:** `/libraries/AP_HAL_ChibiOS/hwdef/TMotorH743/`

## Additional Delays Found - For Future Testing

### **1. IMU Consistency Check - 10 Second Delay (MAJOR BLOCKER)**
**File:** `libraries/AP_Arming/AP_Arming.cpp`
- **Lines 433 & 458:** Requires 10 seconds of consistent readings from multiple IMUs
- **Current Code:**
  ```cpp
  if (ins.get_accel_count() > 1 && now - last_accel_pass_ms < 10000) {
      return false;
  }
  if (ins.get_gyro_count() > 1 && now - last_gyro_pass_ms < 10000) {
      return false;
  }
  ```
- **Fix:** Change `< 10000` to `< 0` or `< 100` (risky but effective)

### **2. Motor ARM_DELAY Constants**
**File:** `ArduCopter/motors.cpp`
- **Lines 3-4:**
  ```cpp
  #define ARM_DELAY               20  // called at 10hz so 2 seconds
  #define DISARM_DELAY            20  // called at 10hz so 2 seconds
  ```
- **Fix:** Change to `#define ARM_DELAY 0`

### **3. Safety Switch Blocking**
**File:** `ArduCopter/AP_Arming_Copter.cpp:643`
- **Current:** Blocks arming if safety switch engaged
- **Fix:** Set parameter `BRD_SAFETYENABLE = 0` or disable in hardware

## Modification Options

### **Option 1: Conservative (Recommended for Testing)**
1. Reduce `ARM_DELAY` from 20 to 0 in `motors.cpp:3`
2. Set parameters via Mission Planner:
   - `ARMING_CHECK = 0` (disable pre-arm checks)
   - `BRD_SAFETYENABLE = 0` (disable safety switch)

### **Option 2: Aggressive (Fastest but Riskier)**
1. All Option 1 changes PLUS
2. Modify IMU consistency timeouts from 10000ms to 0ms in `AP_Arming.cpp:433,458`
3. **⚠️ Warning:** Bypasses important safety checks

### **Option 3: Parameter-Only (No Code Changes)**
Test with current firmware and these parameters:
- `ARMING_CHECK = 0`
- `BRD_SAFETYENABLE = 0`
- `ARMING_REQUIRE = 0`

## File Locations for Reference
- **Main arming logic:** `ArduCopter/AP_Arming_Copter.cpp`
- **IMU delays:** `libraries/AP_Arming/AP_Arming.cpp:433,458`
- **Motor delays:** `ArduCopter/motors.cpp:3-4,76,92`
- **Config constants:** `ArduCopter/config.h`

## Testing Notes
1. Test current firmware first with 0-second `ARMING_DELAY_SEC`
2. If still experiencing delays, likely caused by IMU consistency checks (10 seconds)
3. Consider using single-IMU configuration to avoid multi-IMU delays
4. Monitor for any safety implications during testing

## Build Commands
```bash
cd ../ardupilot-4.7.0-dev
export PATH=/Applications/ArmGNUToolchain/11.3.rel1/arm-none-eabi/bin:$PATH

# For T-Motor H7 Mini
./waf configure --board TMotorH743
./waf copter
```

## Hardware Features (T-Motor H7 Mini)
- STM32H743VIT6 processor (480 MHz)
- ICM42688/BMI270 IMU
- DPS310 barometer
- **NO SD card** - 128Mbits onboard flash only
- USB-C connector
- 5 PWM outputs (4 motor + 1 LED)
- Built-in OSD (AT7456E)
- High-quality build
- T-Motor brand reliability
- Battery monitoring: 2S-6S, up to 130A
- Dual BEC: 5V/2A + 10V/1.5A

---
*Generated: October 22, 2024*
*ArduPilot 4.7.0-dev with custom 0-second arming delay for T-Motor H7 Mini*