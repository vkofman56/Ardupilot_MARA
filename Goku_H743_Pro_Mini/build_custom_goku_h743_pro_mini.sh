#!/bin/bash

# Build script for custom ArduCopter firmware for Goku H743 Pro Mini (FlywooH743Pro)
# This board is compatible with the FlywooH743Pro board configuration
# Hardware specifications:
#   - MCU: STM32H743VIH6 @ 480MHz
#   - IMU: Dual ICM42688P gyroscopes
#   - Barometer: SPL06
#   - OSD: AT7456E
#   - 13 PWM/DShot outputs (12 motors + 1 LED)
#   - 7 UART ports
#   - Flash: 500MB onboard
#   - Battery: 2S-6S support

echo "Building custom ArduCopter firmware for Goku H743 Pro Mini..."
echo "Board: FlywooH743Pro"
echo ""
echo "Hardware specs:"
echo "  - MCU: STM32H743VIH6 @ 480 MHz"
echo "  - IMU: Dual ICM42688P"
echo "  - Barometer: SPL06"
echo "  - 13 PWM outputs (bi-directional DShot on channels 1-10)"
echo "  - 7 UART ports with predefined functions"
echo "  - OSD support (AT7456E)"
echo ""

# Navigate to ardupilot directory
cd /home/user/Ardupilot_MARA/ardupilot-4.7.0-dev

# Install Python dependencies if needed
echo "Installing Python dependencies..."
python3 -m pip install --user --break-system-packages future pexpect
python3 -m pip install --user --break-system-packages empy==3.3.4

# Clean previous build (optional, uncomment if needed)
# echo "Cleaning previous build..."
# ./waf distclean

# Configure for FlywooH743Pro board with custom hwdef for flash support
echo "Configuring for FlywooH743Pro board with Goku flash support..."
CUSTOM_HWDEF="/home/user/Ardupilot_MARA/Goku_H743_Pro_Mini/hwdef-goku.dat"
echo "Using custom hwdef: $CUSTOM_HWDEF"
./waf configure --board FlywooH743Pro --extra-hwdef "$CUSTOM_HWDEF"

# Build ArduCopter
echo "Building ArduCopter..."
./waf copter

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "##############################################"
    echo "Build successful!"
    echo "Firmware file location:"
    echo "  build/FlywooH743Pro/bin/arducopter.apj"
    echo "  build/FlywooH743Pro/bin/arducopter.bin"
    echo "  build/FlywooH743Pro/bin/arducopter_with_bl.hex"
    echo ""
    echo "Board Information:"
    echo "  Name: Goku H743 Pro Mini (FlywooH743Pro compatible)"
    echo "  MCU: STM32H743VIH6 (480 MHz)"
    echo "  IMU: Dual ICM42688P"
    echo "  Barometer: SPL06"
    echo "  Features: 500MB NAND flash logging (LittleFS), 7 UARTs, 13 PWM outputs, OSD"
    echo "  Flash CS: PA15 (beeper disabled)"
    echo ""
    echo "UART Mapping:"
    echo "  SERIAL0 -> USB"
    echo "  SERIAL1 -> UART1 (User, DMA-enabled)"
    echo "  SERIAL2 -> UART2 (RX, DMA-enabled)"
    echo "  SERIAL3 -> UART3 (User)"
    echo "  SERIAL4 -> UART4 (GPS, DMA-enabled)"
    echo "  SERIAL6 -> UART6 (ESC Telemetry)"
    echo "  SERIAL7 -> UART7 (User)"
    echo "  SERIAL8 -> UART8 (DisplayPort, DMA-enabled)"
    echo ""
    echo "Initial firmware load:"
    echo "  Use DFU mode (hold bootloader button while plugging in USB)"
    echo "  Flash 'arducopter_with_bl.hex' using dfu-util or STM32CubeProgrammer"
    echo ""
    echo "Firmware updates:"
    echo "  Upload the .apj file using Mission Planner or QGroundControl"
    echo ""
    echo "Flash Logging:"
    echo "  - 500MB onboard NAND flash with LittleFS filesystem"
    echo "  - Logs stored on SPI3 flash (PA15=CS)"
    echo "  - LOG_BACKEND_TYPE should auto-detect (or set to 1)"
    echo "  - Note: Beeper on PA15 is disabled for flash support"
    echo "##############################################"
else
    echo "Build failed. Please check the error messages above."
    exit 1
fi
