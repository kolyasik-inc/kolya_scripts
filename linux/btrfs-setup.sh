#!/bin/bash

echo "Enter the storage device where the Btrfs file system is located (/dev/sdX):"
read btrfsDevice

echo "Enter the path to the mount point directory (e.g., '/target' or '/mnt'):"
read mountPoint

echo "Is the storage device an HDD or SSD? (Type 'hdd' or 'ssd'):"
read storageType

if [ "$storageType" = "ssd" ]; then
    mountOptions="noatime,compress=zstd,ssd,discard=async,space_cache=v2"
elif [ "$storageType" = "hdd" ]; then
    mountOptions="relatime,compress=zstd:3,nossd,space_cache=v2,autodefrag"
else
    echo "Unrecognized storage type."
    exit 1
fi

mount "$btrfsDevice" "$mountPoint"

subVolumes=()

for eachVolume in "$mountPoint"/*; do
    if [ -f "$eachVolume" ] || [ -d "$eachVolume" ]; then
        subvolName=$(basename "$eachVolume")
        subVolumes+=("$subvolName")
    fi
done

umount -R "$mountPoint"

for mountVolume in "${subVolumes[@]}"; do
  mountCommand="mount -o subvol=$mountVolume,$mountOptions $btrfsDevice $mountPoint"
  case "$mountVolume" in
    "@")
      $mountCommand
      ;;
    "@home")
      "$mountCommand"/home
      ;;
    "@root")
      "$mountCommand"/root
      ;;
    "@opt")
      "$mountCommand"/opt
      ;;
    "@srv")
      "$mountCommand"/srv
      ;;
    "@var")
      "$mountCommand"/var
      ;;
    "@tmp")
      "$mountCommand"/tmp
      ;;
    "@log")
      "$mountCommand"/log
      ;;
    "@usr@local")
      "$mountCommand"/usr/local
      ;;
    "@snapshots")
      "$mountCommand"/.snapshots
      ;;
    "@gdm")
      "$mountCommand"/var/lib/gdm3
      ;;
    "@containers")
      "$mountCommand"/var/lib/containers
      ;;
    "@AccountsService")
      "$mountCommand"/var/lib/AccountsService
      ;;
    "@images")
      "$mountCommand"/var/lib/libvirt/images
      ;;
    *)
      echo "Unrecognized mount volume: $mountVolume"
      ;;
  esac
done
