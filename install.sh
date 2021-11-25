#!/usr/bin/env bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Enable spi
echo "dtparam=spi=on" >> /boot/config.txt

# System Updates & Install dependencies
apt update --yes
apt upgrade --yes
apt install python3-rpi.gpio python3-pip --yes
pip3 install mfrc522

# Install identypi
git pull git@github.com:Nathan-Mossaad/identypi.git
mkdir /usr/share/identypi
touch /usr/share/identypi/users
mv identypi/files/identypi.py /usr/share/identypi/identypi.py
mv identypi/files/identypi /usr/bin/identypi
mv identypi/files/identypi.conf /etc/identypi.conf
mv identypi/files/identypi.service /etc/systemd/system/identypi.service
mv identypi/files/get-id.py /usr/share/identypi/get-id.py
rm -rf identypi

# Enable identypi
systemctl enable identypi.service
echo "don't forget to add a user ATER rebooting: identypi -h"
sleep 10s
reboot
