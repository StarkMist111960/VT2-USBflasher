#!/bin/bash
# Simple USB Image Flasher for ChromeOS VT2
# Author: StarkMist111960

set -e

DOWNLOADS_DIR="/home/chronos/user/Downloads"

echo "=== ChromeOS USB Image Flasher ==="
echo

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (use 'sudo su' first)."
  exit 1
fi

# Find USB drives
echo "Available drives:"
lsblk -o NAME,SIZE,MODEL,MOUNTPOINT | grep -E "sd|mmc"
echo
read -p "Enter the device path (e.g., /dev/sda): " DEVICE

# Confirm device exists
if [ ! -b "$DEVICE" ]; then
  echo "Error: Device not found."
  exit 1
fi

# Find image files
echo
echo "Searching for image files in $DOWNLOADS_DIR..."
mapfile -t images < <(find "$DOWNLOADS_DIR" -maxdepth 1 -type f \( -name "*.img" -o -name "*.iso" \))

if [ ${#images[@]} -eq 0 ]; then
  echo "No .img or .iso files found in $DOWNLOADS_DIR"
  exit 1
fi

echo
echo "Available image files:"
for i in "${!images[@]}"; do
  echo "$((i+1))) ${images[$i]}"
done

read -p "Select an image number: " IMG_CHOICE

IMAGE="${images[$((IMG_CHOICE-1))]}"

if [ ! -f "$IMAGE" ]; then
  echo "Invalid selection."
  exit 1
fi

echo
echo "You are about to flash:"
echo "  Image:  $IMAGE"
echo "  Target: $DEVICE"
read -p "Are you sure? (y/N): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

echo
echo "Flashing... this may take several minutes."
echo "Progress will be shown below."

# Unmount partitions if any
umount ${DEVICE}?* 2>/dev/null || true

# Write image
dd if="$IMAGE" of="$DEVICE" bs=4M status=progress conv=fsync

sync
echo
echo "✅ Flash complete!"
echo "You may now safely remove your USB drive."
