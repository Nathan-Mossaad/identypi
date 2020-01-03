#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

raspi-config
apt update --yes
apt upgrade --yes
apt install python-rpi.gpio python-rpi.gpio python3-rpi.gpio --yes
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.50.tar.gz
tar -zxf bcm2835-1.50.tar.gz
rm bcm2835-1.50.tar.gz
cd bcm2835-1.50/
./configure
make check
make install
cd  ..
rm -r bcm2835-1.50/

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

wget https://github.com/Nathan-Mossaad/identypi/raw/master/identypi.tar.gz
tar -xf identypi.tar.gz
rm identypi.tar.gz
mv identypi/users /usr/share/identypi/users
mv identypi/identypi.py /usr/share/identypi/identypi.py
mv identypi/identypi /usr/bin/identypi
mv identypi/identypi.conf /etc/identypi.conf
mv identypi/identypi.service /etc/systemd/system/identypi.service
rmdir identypi

systemctl enable identypi.service
echo "please reboot to start identypi"
echo "don't forget to add a user ATER rebooting: identypi -h"
rm install.sh
