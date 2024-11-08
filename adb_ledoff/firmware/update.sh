#!/bin/sh

#export led pin
echo 93 > /sys/class/gpio/export

chmod +x /sdcard/firmware/usrrun.sh
./sdcard/firmware/usrrun.sh

#interrupt parent script
exit 0


