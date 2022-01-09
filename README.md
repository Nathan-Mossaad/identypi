# identypi for raspian on a raspberry pi (3)

This project assumes that you run Raspberry Pi OS Lite: https://www.raspberrypi.com/software/operating-systems/

Furthermore the RFID-RC522 module should be hooked up as shown here: https://pimylifeup.com/wp-content/uploads/2017/10/RFID-Fritz-v2.png

(Hookup the Relay as you configured it)

## Requirements:

```sudo apt install wget --yes```

## Installation (requires internet access):

```wget -q -O - https://raw.githubusercontent.com/Nathan-Mossaad/identypi/master/install.sh | sudo bash && sudo reboot```

## Usage

```sudo identypi```
