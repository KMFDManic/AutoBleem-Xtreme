#!/bin/sh

DEST_PATH=/tmp/usb_network
SOURCE_PATH=/media/retroarch/retroboot/usb_network

# Skip doing this if we've done this already
if [ -d $DEST_PATH ]; then
    exit
fi

# Copy files out of the update pack
mkdir -p $DEST_PATH
cp "$SOURCE_PATH/busybox" "$DEST_PATH"
cp "SOURCE_PATH/passwd" "$DEST_PATH"
chmod +x $DEST_PATH/busybox

# Overmount /etc/passwd
mount -o bind $DEST_PATH/passwd /etc/passwd

# Copy /etc/systemd to temp location and overmount so we can add services
cp -r /etc/systemd/ $DEST_PATH
mount -o bind $DEST_PATH/systemd /etc/systemd

# Add telnetd service
cp "$SOURCE_PATH/telnet.socket" /etc/systemd/system/
cp "$SOURCE_PATH/telnet@.service" /etc/systemd/system/
cp "$SOURCE_PATH/ftp.socket" /etc/systemd/system/
cp "$SOURCE_PATH/ftp@.service" /etc/systemd/system/
chmod 664 /etc/systemd/system/telnet.socket /etc/systemd/system/telnet@.service /etc/systemd/system/ftp.socket /etc/systemd/system/ftp@.service/
systemctl daemon-reload

# Enable gadget
echo 0 > /sys/class/android_usb/android0/enable
echo rndis,acm > /sys/class/android_usb/android0/functions
echo tty > sys/class/android_usb/android0/f_acm/acm_transports
echo 0 > /sys/class/android_usb/android0/bDeviceClass
echo 1 > /sys/class/android_usb/android0/f_rndis/wceis
echo 1 > /sys/class/android_usb/android0/f_acm/instances
echo 1 > /sys/class/android_usb/android0/enable
sleep 5

# Config network and start telnet socket listening
ifconfig rndis0 169.254.215.100 netmask 255.255.0.0
systemctl start telnet.socket
