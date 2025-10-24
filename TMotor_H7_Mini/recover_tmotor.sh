#!/bin/bash

# T-Motor H7 Mini Recovery Script
# Run this ONLY after entering DFU mode (hold BOOT button + connect USB)

echo "T-Motor H7 Mini Recovery Script"
echo "================================"
echo ""
echo "PREREQUISITES:"
echo "1. Board must be in DFU mode (hold BOOT + connect USB)"
echo "2. STM32CubeProgrammer must be installed"
echo ""

# Check if STM32_Programmer_CLI is available
if ! command -v STM32_Programmer_CLI &> /dev/null; then
    echo "ERROR: STM32_Programmer_CLI not found!"
    echo "Please install STM32CubeProgrammer and add to PATH"
    echo "Download from: https://www.st.com/en/development-tools/stm32cubeprog.html"
    exit 1
fi

echo "Step 1: Flashing bootloader..."
STM32_Programmer_CLI -c port=usb1 -w ../ardupilot-4.7.0-dev/Tools/bootloaders/TMotorH743_bl.bin 0x08000000 -v

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Bootloader flashed successfully!"
    echo ""
    echo "Step 2: Power cycle the board (disconnect and reconnect USB)"
    echo "Then run this command to flash firmware:"
    echo ""
    echo "STM32_Programmer_CLI -c port=usb1 -w ../ardupilot-4.7.0-dev/build/TMotorH743/bin/arducopter.bin 0x08020000 -v"
    echo ""
    echo "OR use Mission Planner to flash the .apj file after bootloader recovery"
else
    echo ""
    echo "❌ Bootloader flash failed!"
    echo "Make sure the board is in DFU mode:"
    echo "1. Hold BOOT button"
    echo "2. Connect USB cable"
    echo "3. Hold BOOT for 5 seconds, then release"
    echo "4. Run: system_profiler SPUSBDataType | grep -i stm"
fi