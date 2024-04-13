#!/bin/bash

USB_DRIVE=$1
WIN_ISO=$2

if [ -z "$1" ]; then
	echo "No usb drive passed."
	exit 1
fi

if [ -z "$1" ]; then
	echo "No Windows ISO file passed."
	exit 1
fi

echo Installing WIM Tools for File Split...
sudo apt install -y wimtools > /dev/null 2>&1

echo Unmount USB Stick....
sudo umount ${USB_DRIVE}* > /dev/null 2>&1

echo Creating Partition Layout on USB Stick....
#delete the USB partition, create GPT layout, new partition 1, defaults, confirm old signature removal, write
(echo d; echo 1; echo d; echo 1; echo d; echo 1; echo g; echo n; echo 1; echo; echo; echo Y; echo t; echo 11; echo w) | sudo fdisk ${USB_DRIVE} > /dev/null 2>&1

echo Creating Filesystem on USB Stick....
sudo mkfs.vfat -F 32 -n WINDOWS ${USB_DRIVE}1 > /dev/null 2>&1

echo Creating temp mount points, Mounting Windows ISO and USB Stick for file copy....
sudo umount /mnt/tmp > /dev/null 2>&1
sudo umount /mnt/usbwin > /dev/null 2>&1
sudo rm -rf /mnt/tmp > /dev/null 2>&1
sudo rm -rf /mnt/usbwin > /dev/null 2>&1
sudo mkdir /mnt/tmp > /dev/null 2>&1
sudo mkdir /mnt/usbwin > /dev/null 2>&1
sudo mount "${WIN_ISO}" /mnt/tmp > /dev/null 2>&1
sudo mount ${USB_DRIVE}1 /mnt/usbwin > /dev/null 2>&1

echo Copying Windows Install Files to USB...
cd /mnt/tmp
sudo find . -type f ! -name "install.wim" -exec cp --parents '{}' /mnt/usbwin \;

sudo wimlib-imagex split ./sources/install.wim /mnt/usbwin/sources/install.swm 3999
cd /mnt

echo Syncing Disks before cleanup...
sudo sync

echo Unmounting Windows ISO and USB Stick, cleanup temp mount points....
sudo umount /mnt/tmp > /dev/null 2>&1
sudo umount /mnt/usbwin > /dev/null 2>&1
sudo rmdir /mnt/tmp > /dev/null 2>&1
sudo rmdir /mnt/usbwin > /dev/null 2>&1
sudo eject ${USB_DRIVE}

echo
echo Done. You can reboot, and boot from this USB Stick into Windows Setup.
echo If you want to look at the USB Stick in Linux, remove and re-insert it.


