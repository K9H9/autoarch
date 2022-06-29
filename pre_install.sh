#!/bin/sh

#correct kb layout
loadkeys fi

#setting time
timedatectl set-ntp true

#filesystems
mkfs.fat -F32 /dev/nvme0n1p5
mkfs.ext4 /dev/nvme0n1p6

#mount the filesystems
mount --mkdir /dev/nvme0n1p5 /mnt/boot/efi
mount /dev/nvme0n1p6 /mnt/

#Install base system
pacstrap /mnt base base-devel linux-linux-firmware linux-headers

#Generating filesystemtable
genfstab -U /mnt >> /mnt/etc/fstab

#Entering actual installation/exiting live medium
arch-chroot /mnt


