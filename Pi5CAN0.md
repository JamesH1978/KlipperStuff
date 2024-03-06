# Guides and notes for Klipper 
## Setting up a raspberry pi 5 or other bookworm based OS for CAN0

Little bit of history on this one, in the good old days of Buster and Bullseye
networking was handled by dhcpcd. So all you had to do was add a file
/etc/network/interfaces.d and call it can0

In these modern times networking is handled by NetworkManager(NM) and
as such a new file has to be created.
```
sudo nano /etc/systemd/network/80-can.network
```
Paste in the following:
```
[Match]
Name=can*

[CAN]
BitRate=1M
```
**CTRL-X** then **Y** and **Enter** to save

Then run
```
sudo systemctl enable systemd-networkd --now
```
We also need to up the txqueuelen value to 128, this is done with a service file
```
sudo nano /etc/systemd/system/can-up.service
```
Paste in the following:
```
[Service]
Type=oneshot
ExecStart=/usr/sbin/ifconfig can0 txqueuelen 128

[Install]
WantedBy=sys-subsystem-net-devices-can0.device
```
**CTRL-X** then **Y** and **Enter** to save
then activate it with:
```
sudo systemctl enable can-up.service
```
reboot the host
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
