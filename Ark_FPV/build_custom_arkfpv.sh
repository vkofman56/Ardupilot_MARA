#!/bin/bash

# Build script for custom ArduCopter firmware for ARKV6X with 0-second arming delay
# The arming delay has already been modified in config.h

echo "Building custom ArduCopter firmware for ARKV6X..."
echo "Arming delay set to 0 seconds"

# Set up the toolchain path
export PATH=/Applications/ArmGNUToolchain/11.3.rel1/arm-none-eabi/bin:$PATH

# Navigate to ardupilot directory
cd ../ardupilot-latest

# Install Python dependencies if needed
echo "Installing Python dependencies..."
python3 -m pip install --user --break-system-packages future empy pexpect

# Configure for ARKV6X board
echo "Configuring for ARKV6X board..."
./waf configure --board ARKV6X

# Build ArduCopter
echo "Building ArduCopter..."
./waf copter

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "##############################################"
    echo "Build successful!"
    echo "Firmware file location:"
    echo "  build/ARKV6X/bin/arducopter.apj"
    echo "  build/ARKV6X/bin/arducopter.bin"
    echo ""
    echo "You can upload the .apj file using Mission Planner or QGroundControl"
    echo "##############################################"
else
    echo "Build failed. Please check the error messages above."
fi