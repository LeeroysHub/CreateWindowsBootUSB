usb-win-installer.sh

# This script will destroy your USB stick!

# Copies a Windows's 11 ISO to USB, for EFI Boot.

# Make script executable.
chmod +x ./usb-win-installer.sh

# Get list of block devices
lsblk

# How to call script:
./usb-win-installer.sh <PathToUsbDevice> <PathToWindowsISO>

# example
./usb-win-installer.sh /dev/sda ./Windows11.ISO

