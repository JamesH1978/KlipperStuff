# Guides and notes for Klipper 
## using serial uart on a print board and rpi 3/4/0

```
sudo raspi-config
```
* Interface Options
* Serial Port
* no to Would you like a login shell to be accessible over serial?
* yes to  Would you like the serial port hardware to be enabled?
* OK
* Finish
* yes to reboot
 ```
sudo nano /boot/config.txt
```
* add _dtoverlay=disable-bt_ to under the [all] section, also make sure _enable_uart=1_ is under this section too, this enables serial on the full uart ttyAMA0. Some older builds of raspbian/rpios with pi3 may need _dtoverlay=pi3-disable-bt_ instead.

The difference between the mini-uart on ttyS0(default uart on gpio14/15) and the full-uart on ttyAMA0 is well documented online, but ttyAMA0 is technically better to use, although the mini-uart works in general.
* ctrl-x and save
```
sudo systemctl disable hciuart.service
sudo systemctl disable bluealsa.service
sudo systemctl disable bluetooth.service
#some of these may not be found, it is a catch all set of commands for pi3/4/0
sudo reboot
```
* some of these may not be found, it is a catch all set of commands for pi3/4/0

In terms of wiring, 3 wires are needed for serial to work: TX, RX and ground 

* RX on board goes to gpio14 and TX goes to gpio15, and use any ground
* Some boards can power the pi over the 5v pin as well, but fair warning, make sure your board can provide enough power and do not use standard dupont jumpers they usually do not have the AWG to handle the current
 
You now need to build your firmware on the correct comms port
use your boards repo to find which pins on which UART to use
You will need to look at the pin PDF in the appropriate repo to find the location of the RX/TX pins and then the SCH schematic PDF to find out the pins. Sometimes it will tell you the UARTx number in the pin PDF, so you can use that to match what make menuconfig shows as the options for UART
 
all that remains is to change the serial: in [mcu] in printer.cfg to use the serial
```
[mcu]
serial: /dev/serial0
baud: 250000
restart_method: command
```