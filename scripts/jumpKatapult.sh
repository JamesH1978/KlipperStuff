#!/bin/bash
cd ~/klipper/scripts
python3 -c 'import flash_usb as u; u.enter_bootloader("\dev\serial\by-id\...")'