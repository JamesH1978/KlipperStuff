# Guides and notes for Klipper 
## Flashing an EBB with Katapult and Klipper for CAN

Add the jumper to the board for usb power and connect to the host in DFU mode
Make sure the can cabling and power is not connected

Make sure EBB is in DFU mode
```
lsusb
```
This should return an entry marked **STM32 Device in DFU Mode** with the address: 
```
0483:df11
```
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
![katapult_flash_settings](/files/EBBFlash.png)

Flash the created bin file using dfu-util

```
sudo dfu-util -a 0 -D ~/katapult/out/katapult.bin --dfuse-address 0x08000000:force:mass-erase:leave -d 0483:df11
```

the board should now be flashed for the Katapult bootloader

You can now remove the USB power jumper, add the 120r jumper and connect the external power and CAN interface

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
* Note this uuid down, so you know it is your EBB

We can now go ahead and prepare and flash Klipper

```
cd ~/klipper
make clean
make menuconfig
make
```
![klipper_flash_settings](/files/EBBKlipperFlash.png)
```
cd ~/katapult/scripts
python3 flashtool.py -i can0 -f ~/klipper/out/klipper.bin -u 33fdea008eda
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
[mcu EBB]
canbus_uuid: 22fdec008eda
```
* EBB can be whatever you want to call it



