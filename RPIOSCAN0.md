# Guides and notes for Klipper 
## Setting up RPiOS for CAN0, or other Buster/Bullseye based OS

```
sudo nano /etc/network/interfaces.d/can0
```
Paste in the following
```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```
**CTRL-X** then **Y** and **Enter** to save
```
sudo reboot
```
You should now find your CAN0 is UP in
```
ip addr
```
Which should output similar to:
```
6: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP group default qlen 128
    link/can
```