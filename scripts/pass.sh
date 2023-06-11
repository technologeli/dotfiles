#!/usr/bin/env bash

F=$(rg --files ~/.password-store/ | fzf)
N=$(echo "$F" | cut -d "/" -f 5- | cut -d "." -f 1)
pass $@ "$N"

