#!/bin/bash
cd ~/klipper/scripts
systemctl stop klipper
python3 -c 'import flash_usb as u; u.enter_bootloader("\dev\serial\by-id\...")'