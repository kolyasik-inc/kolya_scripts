#!/bin/bash

read -p "Enter the storage device where the Btrfs file system is located (/dev/sdX): " mountDevice
read -p "Enter the path to the mount directory (e.g., '/target' or '/mnt'): " mountDirectory
read -p "Is the storage device an HDD or SSD? (Type 'hdd' or 'ssd'): " storageType

if [ "$storageType" = "ssd" ]; then
    mountOptions="noatime,compress=zstd:3,space_cache=v2,ssd,discard=async"
elif [ "$storageType" = "hdd" ]; then
    mountOptions="relatime,compress=zstd:3,space_cache=v2,nossd,autodefrag"
else
    echo "Unrecognized storage type."
    exit 1
fi

mount -o	$mountOptions,subvol=@			$mountDevice	$mountDirectory
mount -o	$mountOptions,subvol=@home		$mountDevice	$mountDirectory/home
mount -o	$mountOptions,subvol=@root		$mountDevice	$mountDirectory/root
mount -o	$mountOptions,subvol=@opt		$mountDevice	$mountDirectory/opt
mount -o	$mountOptions,subvol=@srv		$mountDevice	$mountDirectory/srv
mount -o	$mountOptions,subvol=@var		$mountDevice	$mountDirectory/var
mount -o	$mountOptions,subvol=@tmp		$mountDevice	$mountDirectory/tmp
mount -o	$mountOptions,subvol=@swap		$mountDevice	$mountDirectory/swap
mount -o	$mountOptions,subvol=@log		$mountDevice	$mountDirectory/var/log
mount -o	$mountOptions,subvol=@usr@local		$mountDevice	$mountDirectory/usr/local
mount -o	$mountOptions,subvol=@snapshots		$mountDevice	$mountDirectory/.snapshots
mount -o	$mountOptions,subvol=@gdm3		$mountDevice	$mountDirectory/var/lib/gdm3
mount -o	$mountOptions,subvol=@containers	$mountDevice	$mountDirectory/var/lib/containers
mount -o	$mountOptions,subvol=@AccountsServices	$mountDevice	$mountDirectory/var/lib/AccountsServices
mount -o	$mountOptions,subvol=@images	 	$mountDevice	$mountDirectory/var/lib/libvirt/images
