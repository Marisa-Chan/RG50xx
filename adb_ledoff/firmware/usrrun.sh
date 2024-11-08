#!/bin/sh

export HOME="/oem"
export PATH="/usr/bin:/usr/sbin:/oem/release/bin"
export LD_LIBRARY_PATH="/lib:/usr/lib:/oem/release/bin"

echo usb_mtp_en > /tmp/.usb_config
echo usb_adb_en >> /tmp/.usb_config

/etc/init.d/S50usbdevice restart

APP=gamebox
if [ -f "/oem/stop" ]; then
	out=0
else
	start-stop-daemon -b -m -S -p /var/run/vol_adj.pid vol_adj

	start-stop-daemon -b -m -S -p /var/run/gamebox.pid $APP

	sleep 1s

	gui=/proc/$(cat /var/run/gamebox.pid)
	retro=/proc/000

	out=1
	
	
	#disable led
	echo 0 > /sys/class/gpio/gpio93/value
fi

while [ $out -eq 1 ]
do
	if [ -f "/tmp/reboot" ] || [ -f "/tmp/halt" ] || [ -f "/tmp/loader" ]; then
		start-stop-daemon -K -q -p /var/run/vol_adj.pid
		out=0
	else
		if [ ! -d $gui ] && [ ! -d $retro ]; then
			if [ -f "/tmp/game.cfg" ]; then
				start-stop-daemon -b -m -S -p /var/run/retroarch.pid retroarch
				sleep 1s
				retro=/proc/$(cat /var/run/retroarch.pid)
			else
				start-stop-daemon -b -m -S -p /var/run/gamebox.pid $APP
				sleep 1s
				gui=/proc/$(cat /var/run/gamebox.pid)
				
				#disable led
				echo 0 > /sys/class/gpio/gpio93/value
			fi
		elif [ -f "/tmp/lowpower" ]; then
			if [ -d $retro ]; then
				start-stop-daemon -K -q -p /var/run/retroarch.pid
				sleep 1s
			fi
			rm /tmp/lowpower
		else
			sleep 1s
		fi
	fi
done

if [ -f "/tmp/loader" ]; then
	reboot loader
fi

if [ -f "/tmp/reboot" ]; then
	reboot
fi

if [ -f "/tmp/halt" ]; then
	poweroff -f
fi
