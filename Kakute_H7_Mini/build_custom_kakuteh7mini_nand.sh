#!/bin/bash

# Build script for custom ArduCopter firmware for Kakute H7 Mini v1.3 (NAND variant) with 0-second arming delay
# This is for Kakute H7 Mini v1.3 boards that use BMI270 IMU and NAND flash memory
# The arming delay has already been modified in config.h

echo "Building custom ArduCopter firmware for Kakute H7 Mini v1.3 (NAND variant)..."
echo "Board ID: 1058 (same as regular, but different hardware config)"
echo "Arming delay set to 0 seconds"
echo ""
echo "Hardware differences from v1.5:"
echo "  - IMU: BMI270 (instead of MPU6000)"
echo "  - Flash: 1GBit NAND flash (instead of 128Mbits regular flash)"
echo "  - Storage driver: littlefs:w25nxx (instead of regular dataflash)"
echo ""

# Set up the toolchain path
export PATH=/Applications/ArmGNUToolchain/11.3.rel1/arm-none-eabi/bin:$PATH

# Navigate to ardupilot directory
cd ../ardupilot-4.7.0-dev

# Install Python dependencies if needed
echo "Installing Python dependencies..."
python3 -m pip install --user --break-system-packages future empy pexpect

# Configure for Kakute H7 Mini NAND board
echo "Configuring for Kakute H7 Mini NAND board..."
./waf configure --board KakuteH7Mini-Nand

# Build ArduCopter
echo "Building ArduCopter..."
./waf copter

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "##############################################"
    echo "Build successful!"
    echo "Firmware file location:"
    echo "  build/KakuteH7Mini-Nand/bin/arducopter.apj"
    echo "  build/KakuteH7Mini-Nand/bin/arducopter.bin"
    echo ""
    echo "Board Information:"
    echo "  Name: Kakute H7 Mini v1.3 (NAND variant)"
    echo "  Board ID: 1058"
    echo "  Processor: STM32H743VIT6 (480 MHz)"
    echo "  IMU: BMI270 (with ROTATION_PITCH_180_YAW_90)"
    echo "  Barometer: BMP280"
    echo "  Features: 1GBit NAND flash, USB-C, Built-in OSD (AT7456E)"
    echo "  Storage: NO SD card - NAND flash with littlefs filesystem"
    echo ""
    echo "IMPORTANT: This firmware is specifically for Kakute H7 Mini v1.3 boards!"
    echo "DO NOT use this firmware on v1.5 boards (they need the regular KakuteH7Mini build)"
    echo ""
    echo "You can upload the .apj file using Mission Planner or QGroundControl"
    echo "##############################################"
else
    echo "Build failed. Please check the error messages above."
fi