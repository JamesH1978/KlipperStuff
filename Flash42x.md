# Guides and notes for Klipper 
## Guide for flashing Creality 4.2.x boards

For Creality users on stock v4.2.2 boards(it should also work for most other Creality machines with a v4.2.x board) 

make sure SD is formatted fat/fat32 on a **windows system** and of a size up to 16GB
 ```
cd ~/klipper
make menuconfig
make clean
make
 ```
 ![board flash settings](/files/42xFlash.png)

 Please take heed of the following notes:
* If you have the GD32F103 variant, You may have to select "Enable extra low-level configuration options" and tick "Disable SWD at startup "
* Make sure you do not select usb as the communications type These boards use a CH340 serial to usb chip not the onchip usb
* Make sure you run the make command at the end otherwise a file will not be created

Grab the file from the **~/klipper/out** directory using something like WinSCP

Copy the file to the SD card, call it firmware(somethingUnique).bin eg firmware1110001.bin

* The board keeps the checksum of the name of the last flashed file, so it doesn't firmware flash loop if you keep the card in at reboot
* It does **NOT** change the filename extension on the card after flash like other vendors boards

Turn off printer

Remove usb cable

* Please do this, this board suffers from USB backfeed that can cause issues with the flash process

Insert sd card into print board

Power on printer

Leave 20 secs

Power off printer

Remove card

Power on printer

Connect usb back to host

Reboot host
 
* These boards have no flash signs apart from a connected screen now not working
* If you have a screen it will likely now not work until configures properly
& If you have a modern screen it probably isnt supported by klipper

The old style blue boxy screen for the normal ender3 can be made to work though with the following code:

config changes:
```
[board_pins]
aliases:
  EXP1_1=PC6,EXP1_3=PB10,EXP1_5=PB14,EXP1_7=PB12,EXP1_9=<GND>,
  EXP1_2=PB2,EXP1_4=PB11,EXP1_6=PB13,EXP1_8=PB15,EXP1_10=<5V>,
  PROBE_IN=PB0,PROBE_OUT=PB1,FIL_RUNOUT=PA4

[display]
lcd_type: st7920
cs_pin: EXP1_7
sclk_pin: EXP1_6
sid_pin: EXP1_8
encoder_pins: ^EXP1_5, ^EXP1_3
click_pin: ^!EXP1_2

[output_pin beeper]
pin: EXP1_1
```
* Please use https://github.com/Klipper3d/klipper/blob/master/config/printer-creality-ender3-v2-2020.cfg as your base config
 
* Please use https://www.klipper3d.org/Config_checks.html to check the "sanity" of your config
