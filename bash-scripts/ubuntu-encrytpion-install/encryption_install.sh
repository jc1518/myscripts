#!/bin/bash

# Wipe existing partition
dd if=/dev/zero of=/dev/sda bs=512 count=1

# Set up partition

(echo n; echo p; echo; echo; echo +300M; echo n; echo p; echo; echo; echo +2G; echo n; echo e; echo; echo; echo; echo n; echo l; echo; echo; echo t; echo 2; echo 82; echo w) | sudo fdisk /dev/sda

sudo fdisk -l

# Encrypt disk
sudo cryptsetup -y -v luksFormat /dev/sda5
sudo cryptsetup luksOpen /dev/sda5 sda5_crypt

# Format disk
sudo mkfs.ext2 /dev/sda1
sudo mkswap /dev/sda2
sudo mkfs.ext4 /dev/mapper/sda5_crypt

# Install Ubuntu
ubiquity --desktop %k gtk_ui

# Configure the new system
sudo mount /dev/mapper/sda5_crypt /mnt
sudo chroot /mnt mount /proc
sudo mount --bind /dev /mnt/dev
sudo chroot /mnt mount /boot

echo "sda5_crypt UUID=`sudo blkid -s UUID -o value /dev/sda5` none luks" | sudo tee -a /mnt/etc/crypttab

sudo chroot /mnt update-initramfs -u
sudo umount /mnt/proc /mnt/dev /mnt/boot /mnt
echo rebooting... 
sudo reboot
