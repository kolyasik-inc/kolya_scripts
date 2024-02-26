#!/bin/bash

echo "Enter path of drive you want to mount your boot partition like /dev/sdX1"
read bootDrive
echo "Wanna dedicated swap partition or mount swap in btrfs /dev/sdX2"
read swapDrive
echo "Enter path of drive you want to mount your rootfs like /dev/sdX3"
read rootDrive

mount $rootDrive /mnt

declare -a subvolumes=(@ @home @opt @root @srv @swap @usr@local @var)

for subvol in "${subvolumes[@]}"; do
  if [ ! -d /mnt/$subvol ]; then
    btrfs subvolume create /mnt/$subvol
  fi
done

mount -o subvol=@ $rootDrive /mnt

directories=(boot/efi home opt root srv swap usr/local var)
for dir in "${directories[@]}"; do
  if [ ! -d "/mnt/$dir" ]; then
    mkdir -p "/mnt/$dir"
  fi
done

umount /mnt

echo "Select the type of drive you want to mount (1 or 2):"
echo "1. Solid State Drive"
echo "2. Hard Disk Drive"
read driveType

if [ "$driveType" = "1" ]; then
  options="noatime,compress=zstd,ssd,discard=async,space_cache=v2"
else
  options="noatime,compress=zstd:3,nossd,space_cache=v2,autodefrag"
fi

mount -o $options,subvol=/@ $rootDrive /mnt;
mount -o $options,subvol=/@var $rootDrive /mnt/var/;
mount -o $options,subvol=/@opt $rootDrive /mnt/opt/;
mount -o $options,subvol=/@root $rootDrive /mnt/root/;
mount -o $options,subvol=/@home $rootDrive /mnt/home/;
mount -o $options,subvol=/@srv $rootDrive /mnt/srv/;
mount -o $options,subvol=/@usr@local $rootDrive /mnt/usr/local/;

mount $bootDrive /mnt/boot

echo "Do you want to create a swap file? (y/n)"
read answer

if [ "$answer" == "y" ]; then
  SWAP_FILE=/mnt/swap/swapfile
  
  echo "Enter desired size of swapfile in Megabytes:"
  read swapSizeMB
  mkdir -p /mnt/swap
  mount -o subvol=@swap $rootDrive /mnt/swap
  mkdir -p /mnt/swap
  chmod 700 /mnt/swap
  touch "$SWAP_FILE"
  chmod 600 "$SWAP_FILE"
  chattr +C "$SWAP_FILE"
  btrfs property set "$SWAP_FILE" compression none
  dd if=/dev/zero of="$SWAP_FILE" bs=1M count="$swapSizeMB"
  mkswap "$SWAP_FILE"
  swapon "$SWAP_FILE"
else
  mkswap $swapDrive
  swapon $swapDrive
fi
