#!/bin/bash

read -p "Mount Device: (/dev/sdX) " mountDevice
read -p "Mount Directory: ('/mnt' or '/target') " mountDirectory
mount -o subvol=@ $mountDevice $mountDirectory
mkdir -p $mountDirectory/{home,root,boot,swap,opt,srv,var,tmp,usr/local,.snapshots}
mount -o subvol=@var $mountDevice $mountDirectory/var
mkdir -p $mountDirectory/{var/log,var/lib/gdm3,var/lib/containers,var/lib/AccountsServices,var/lib/libvirt/images}
