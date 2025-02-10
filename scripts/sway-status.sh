#!/usr/bin/env bash

# muted
test "$(dunstctl is-paused)" = "true" && muted="Muted" || muted="Unmuted"

# battery
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | cut -f1 -d%)
test "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')" = "charging" && charging="+" || charging="-"
STATUS_FILE="/tmp/sway-battery"

if [ "$battery" -le 10 ] && [ "$(cat $STATUS_FILE)" != "$charging" ]; then
	if [ "$charging" == "+" ]; then
		notify-send "Charging!"
	else
		notify-send "Low battery!"
	fi
	echo $charging > $STATUS_FILE
fi

# volume
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')

# date
d=$(date +'%Y-%m-%d %I:%M %p')

echo "N:$muted B:$battery% V:$volume% $d"
