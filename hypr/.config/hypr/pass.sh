#!/usr/bin/env bash

prompt="Pass"
if [[ "$1" = "otp" ]] then
    prompt="OTP"
fi

F=$(rg --files ~/.password-store/ | cut -d "/" -f 5- | sed 's/\(.*\)\..*/\1/' | wofi -d --prompt "$prompt")

if [[ -z ${F} ]] then
    notify-send "Pass: Nothing selected."
else
    pass $@ "$F" && notify-send "Pass: Copied $F!" "Clearing clipboard in 45 seconds."
fi
