#!/bin/bash
# menu_plugin
# VT2-USB Flasher by StarkMist111960
PLUGIN_AUTHOR="StarkMist111960"
PLUGIN_VERSION="1.0"

echo "=== VT2 USB Image Flasher ==="
echo "Listing removable drives..."

# List removable drives (skipping internal disks)
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,RM | grep 'disk' | awk '$5 == 1 {print NR ") /dev/"$1 " - " $2}' || {
    echo "No removable drives found."
    exit 1
}

echo
read -p "Enter the number of the USB drive you want to flash: " choice

# Get the actual device name based on the number selected
device=$(lsblk -o NAME,RM | grep ' 1' | awk 'NR=='"$choice"'{print $1}')

if [ -z "$device" ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi

echo
read -p "Enter the full path to the image file (e.g. /root/myimage.img): " image

if [ ! -f "$image" ]; then
    echo "Image file not found!"
    exit 1
fi

echo
echo "You are about to flash '$image' to /dev/$device"
read -p "Are you absolutely sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

echo
echo "Flashing... this may take a while."
sudo dd if="$image" of="/dev/$device" bs=4M status=progress conv=fsync

echo
echo "✅ Done! Image successfully written to /dev/$device"
