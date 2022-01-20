#!/bin/bash
cd ~/
git clone https://github.com/dreamerwise/NeopixelsKlipper.git
mv ./NeopixelsKlipper/* ./
rm -rf NeopixelsKlipper
cd neopixels
sudo mv ./klipper_monitor.service /etc/systemd/system/klipper_monitor.service
systemctl enable klipper_monitor
systemctl start klipper_monitor
