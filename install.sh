#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Enable spi
echo "dtparam=spi=on" >> /boot/config.txt

# System Updates & Install dependencies
apt update --yes
apt upgrade --yes
apt install python3-rpi.gpio git --yes

# Install bcm drivers
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.50.tar.gz
tar -zxf bcm2835-1.50.tar.gz
rm bcm2835-1.50.tar.gz
cd bcm2835-1.50/
./configure
make check
make install
cd  ..
rm -r bcm2835-1.50/

# Install rc522 driver
wget https://github.com/Nathan-Mossaad/rc522-identypi/raw/master/rc522.tar.gz
tar -zxvf rc522.tar.gz
rm rc522.tar.gz
cd rc522
./mc
cp RC522.conf   /etc
chmod 666 /etc/RC522.conf
cd ..
mkdir /usr/share/identypi/
mv rc522/rc522 /usr/share/identypi/rc522
rm -r rc522

# Install identypi
git clone https://github.com/Nathan-Mossaad/identypi.git
touch /usr/share/identypi/users
mv identypi/files/identypi.py /usr/share/identypi/identypi.py
chmod +x /usr/share/identypi/identypi.py
mv identypi/files/identypi /usr/bin/identypi
chmod +x /usr/bin/identypi
mv identypi/files/identypi.conf /etc/identypi.conf
mv identypi/files/identypi.service /etc/systemd/system/identypi.service
rm -rf identypi

systemctl enable identypi.service
echo "please reboot to start identypi"
echo "don't forget to add a user ATER rebooting: identypi -h"
