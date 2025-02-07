#!/usr/bin/env bash

# muted
test "$(dunstctl is-paused)" = "true" && muted="Muted" || muted="Unmuted"

# battery
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | cut -f1 -d%)
if [ $battery -le 10 ]; then
	notify-send "Low battery!"
fi

# volume
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')

# date
d=$(date +'%Y-%m-%d %I:%M %p')

echo "N:$muted B:$battery% V:$volume% $d"
