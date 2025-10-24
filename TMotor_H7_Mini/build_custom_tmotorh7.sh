#!/bin/bash

# Build script for custom ArduCopter firmware for T-Motor H7 Mini with 0-second arming delay
# The arming delay has already been modified in config.h

echo "Building custom ArduCopter firmware for T-Motor H7 Mini..."
echo "Board ID: 1138"
echo "Arming delay set to 0 seconds"

# Set up the toolchain path
export PATH=/Applications/ArmGNUToolchain/11.3.rel1/arm-none-eabi/bin:$PATH

# Navigate to ardupilot directory
cd ../ardupilot-4.7.0-dev

# Install Python dependencies if needed
echo "Installing Python dependencies..."
python3 -m pip install --user --break-system-packages future empy pexpect

# Configure for T-Motor H7 Mini board
echo "Configuring for T-Motor H7 Mini board..."
./waf configure --board TMotorH743

# Build ArduCopter
echo "Building ArduCopter..."
./waf copter

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "##############################################"
    echo "Build successful!"
    echo "Firmware file location:"
    echo "  build/TMotorH743/bin/arducopter.apj"
    echo "  build/TMotorH743/bin/arducopter.bin"
    echo ""
    echo "Board Information:"
    echo "  Name: T-Motor H7 Mini"
    echo "  Board ID: 1138"
    echo "  Processor: STM32H743VIT6 (480 MHz)"
    echo "  IMU: ICM42688/BMI270"
    echo "  Barometer: DPS310"
    echo "  Features: 128Mbits onboard flash, USB-C, Built-in OSD (AT7456E)"
    echo "  Storage: NO SD card - onboard flash only"
    echo "  PWM: 5 outputs (4 motor + 1 LED)"
    echo "  Brand: T-Motor (high quality)"
    echo ""
    echo "You can upload the .apj file using Mission Planner or QGroundControl"
    echo "##############################################"
else
    echo "Build failed. Please check the error messages above."
fi