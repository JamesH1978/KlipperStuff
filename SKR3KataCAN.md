# Guides and notes for Klipper 
## Flashing an SKR3 EZ with Katapult for a CAN bridge setup


Connect SKR3 to host via usb in dfu mode

To do this hold the BOOT0 button down and tap reset

Configure the host for can0

[Buster/Bullseye](RPIOSCAN0.md)

[Bookworm](Pi5CAN0.md)

Clone Katapult if you havent done so already

```
cd ~
git clone https://github.com/Arksine/katapult
```
Enter the make menuconfig settings
```
cd ~/katapult
make menuconfig
make
```
![katapult_flash_settings](/files/KoctopusFlash.png)

_These settings are specifically for the H723 variant, if you habe
the H743 variant, please change the Processor Model_

Flash the created bin file using dfu-util

```
sudo dfu-util -a 0 -D ~/katapult/out/katapult.bin --dfuse-address 0x08000000:force:mass-erase:leave -d 0483:df11
```

the board should now be flashed for the Katapult bootloader
test with:
```
ls /dev/serial/by-id/*
```
you should see an id similar to 
```
/dev/serial/by-id/usb-katapult_stm32h723xx_32001C001051313236343430-if00```
```

We can now go ahead and prepare and flash Klipper

```
cd ~/klipper
make clean
make menuconfig
make
```
![klipper_flash_settings](/files/SKR3EZKlipperFlash.png)

_These settings are specifically for the H723 variant, if you habe
the H743 variant, please change the Processor Model_

Flash the created bin file using flashtool.py

```
pip3 install pyserial
cd ~/katapult/scripts
python3 flashtool.py -d /dev/serial/by-id/usb-katapult_stm32h723xx_32001C001051313236343430-if00
```
_Please remember to use your found by-id_

### Your SKR3 is now flashed for both Katapult and Klipper

you will now find that your board is not available using the command
to find the by-id. This is normal and is due to the fact that the MCU 
will pass onto the canbus. As the klipper docs state "The "bridge mcu" 
is not actually on the CAN bus. Messages to and from the bridge mcu 
will not be seen by other adapters that may be on the CAN bus."

So we need to query it using the flashtool.py utility

```
cd ~/katapult/scripts
python3 flashtool.py -i can0 -q
```

If all has gone well you should now see a uuid with an **Application: Klipper**
```
Resetting all bootloader node IDs...
Checking for Katapult nodes...
Detected UUID: 33fdea008eda, Application: Klipper
Query Complete
```
This is the uuid for your SKR3 and the syntax to use in the printer.cfg
```
[mcu]
canbus_uuid: 33fdea008eda
```



