#!/bin/bash

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@opt
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@usr@local
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@gdm3
btrfs subvolume create /mnt/@containers
btrfs subvolume create /mnt/@AccountsServices
btrfs subvolume create /mnt/@images
