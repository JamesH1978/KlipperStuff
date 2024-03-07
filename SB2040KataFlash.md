# Guides and notes for Klipper 
## Flashing a Mellow Fly SB2040 with Katapult and Klipper for CAN

Clone Katapult if you havent done so already

```
git clone https://github.com/Arksine/katapult
```
Enter the make menuconfig settings
```
cd ~/katapult
make menuconfig
make
```
![katapult_flash_settings](/files/SB2040KataFlash.png)

Press and hold the BOOT button of the SB2040 board, and then connect the usb to the host

Check lsusb for the RP2040 device
```
lsusb
```
you should receive an entry similar to:
```
Raspberry Pi RP2 Boot
```
Once you have confirmed that entry is there then we can flash the bootloader:
```
cd ~/katapult/
make flash FLASH_DEVICE=2e8a:0003
```

the board should now be flashed for the Katapult bootloader

You can now connect the external power and CAN interface

We need to confirm the flash and query it using the flashtool.py utility

```
cd ~/katapult/scripts
python3 flashtool.py -i can0 -q
```

If all has gone well you should now see a uuid with an **Application: Katapult**
```
Resetting all bootloader node IDs...
Checking for Katapult nodes...
Detected UUID: 22fdec008eda, Application: Katapult
Query Complete
```

* You may also see another uuid if you have also flashed another board for CAN
 or a mainboard for USB CAN bridge
* Note this uuid down, so you know it is your SB2040

We can now go ahead and prepare and flash Klipper

```
cd ~/klipper
make clean
make menuconfig
make
```
![klipper_flash_settings](/files/SB2040KlipFlash.png)
```
cd ~/katapult/scripts
python3 flashtool.py -i can0 -f ~/klipper/out/klipper.bin -u 22fdec008eda
```
* Please substitute the uuid you found earlier into the above command

Now we need to query it again using the flashtool.py utility

```
cd ~/katapult/scripts
python3 flashtool.py -i can0 -q
```

If all has gone well this time you should see the same uuid with an **Application: Klipper**
```
Resetting all bootloader node IDs...
Checking for Katapult nodes...
Detected UUID: 22fdec008eda, Application: Klipper
Query Complete
```
The syntax to use in the printer.cfg
```
[mcu SB2040]
canbus_uuid: 22fdec008eda
```
* SB2040 can be whatever you want to call it

## Updating SB2040

This is a fairly simple process now you have katapult installed

First rebuild the bin file
```
cd ~/klipper
git pull
make clean
make menuconfig
make
```
![klipper_flash_settings](/files/SB2040KlipFlash.png)

and then flash it with katapult
```
cd ~/katapult/scripts
systemctl stop klipper
python3 flashtool.py -i can0 -f ~/klipper/out/klipper.bin -u 22fdec008eda
systemctl start klipper
```
_Please remember to substitute your own uuid for the SB2040_

your SB2040 should now be updated