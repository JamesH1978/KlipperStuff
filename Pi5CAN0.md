# Guides and notes for Klipper 
## Setting up a raspberry pi 5 or other bookworm based OS for CAN0

Little bit of history on this one, in the good old days of Buster and Bullseye
networking was handled by dhcpcd. So all you had to do was add a file
/etc/network/interfaces.d and call it can0

In these modern times networking is handled by NetworkManager(NM) and
as such a couple of new file need to be created.
```
sudo nano /etc/systemd/network/80-can0.network
```
Paste in the following:
```
[Match]
Name=can*

[CAN]
BitRate=1M
```
**CTRL-X** then **Y** and **Enter** to save

```
sudo nano /etc/systemd/network/80-can0.link
```
Paste in the following:
```
[Match]
OriginalName=can0

[Link]
TransmitQueueLength=128
```
**CTRL-X** then **Y** and **Enter** to save

Then run
```
sudo systemctl enable systemd-networkd --now

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

You may find your boot times are sub-optimal, this is usually networkd
wait times, so run the following:

_It may ask what editor to use, select nano_

```
sudo systemctl edit --full systemd-networkd-wait-online.service
```
then add

```
--timeout 1
```
Save with ctrl-x, y and enter

then reboot pi
