#!/bin/bash

chmod 700 /mnt/swap
touch /mnt/swap/swapfile
chmod 600 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
btrfs property set /mnt/swap/swapfile compression none
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=4096
mkswap /mnt/swap/swapfile
swapon /mnt/swap/swapfile
