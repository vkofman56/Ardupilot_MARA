#!/bin/bash

# Build script for custom ArduCopter firmware for Kakute H7 Mini v1.5 (regular variant) with 0-second arming delay
# This is for Kakute H7 Mini v1.5 boards that use MPU6000 IMU and regular flash memory
# The arming delay has already been modified in config.h

echo "Building custom ArduCopter firmware for Kakute H7 Mini v1.5 (regular variant)..."
echo "Board ID: 1058"
echo "Arming delay set to 0 seconds"
echo ""
echo "Hardware specs for v1.5:"
echo "  - IMU: MPU6000"
echo "  - Flash: 128Mbits regular onboard flash"
echo "  - Storage driver: regular dataflash"
echo ""

# Set up the toolchain path
export PATH=/Applications/ArmGNUToolchain/11.3.rel1/arm-none-eabi/bin:$PATH

# Navigate to ardupilot directory
cd ../ardupilot-4.7.0-dev

# Install Python dependencies if needed
echo "Installing Python dependencies..."
python3 -m pip install --user --break-system-packages future empy pexpect

# Configure for Kakute H7 Mini board
echo "Configuring for Kakute H7 Mini board..."
./waf configure --board KakuteH7Mini

# Build ArduCopter
echo "Building ArduCopter..."
./waf copter

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "##############################################"
    echo "Build successful!"
    echo "Firmware file location:"
    echo "  build/KakuteH7Mini/bin/arducopter.apj"
    echo "  build/KakuteH7Mini/bin/arducopter.bin"
    echo ""
    echo "Board Information:"
    echo "  Name: Kakute H7 Mini v1.5 (regular variant)"
    echo "  Board ID: 1058"
    echo "  Processor: STM32H743VIT6 (480 MHz)"
    echo "  IMU: MPU6000"
    echo "  Barometer: BMP280"
    echo "  Features: 128Mbits onboard flash, USB-C, Built-in OSD (AT7456E)"
    echo "  Storage: NO SD card - onboard flash only"
    echo ""
    echo "IMPORTANT: This firmware is specifically for Kakute H7 Mini v1.5 boards!"
    echo "For v1.3 boards, use: ./build_custom_kakuteh7mini_nand.sh"
    echo ""
    echo "You can upload the .apj file using Mission Planner or QGroundControl"
    echo "##############################################"
else
    echo "Build failed. Please check the error messages above."
fi