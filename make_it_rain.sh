#!/bin/sh

#Linking time zone
ln -sf /usr/share/zoneinfo/Europe/Helsinki /etc/localtime

# Generating adjtime
hwclock --systohc

#Locales
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

# Networking configuration
echo "Hostname:" ; read hostname ; echo $hostname >> /etc/hostname
echo -ne "
127.0.0.1        localhost
::1              localhost
127.0.1.1        $hostname.localdomain  $hostname
"
pacman -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

# Change default root password
passwd

#Create user
echo "Username for normal user:" ; read $username 
useradd -m $username
#Create password for that user
passwd $username
#Add created user to all necessary groups
useradd -aG wheel,audio,video,optical,storage $username

#Install AUR-helper to install packages from aur-repo
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepgk -si ; cd -1

#Install all system packages
yay -S alacritty neovim firefox-developer-edition nvidia awesome-git picom-animations-git xorg xorg-xinit zsh amd-ucode blueman bluez bluez-utils playerctl brightnessctl discord spotify os-prober dosfstools mtools flameshot imagemagick inotify-tools gtk3 maim openssh pipewire pipewire-pulse wireplumber redshift upower xdotool xclip grub 
#Change default shell
chsh -s /usr/bin/zsh $username

#Install grub to have somewhere to boot
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck
#config for grub
grub-mkconfig -o /boot/grub/grub.cfg

#Enable some services
systemctl enable bluetooth
systemctl start bluetooth


