#!/usr/bin/env bash
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | cut -f1 -d%)
if [ $battery -le 10 ]; then
	notify-send "Low battery!"
fi
