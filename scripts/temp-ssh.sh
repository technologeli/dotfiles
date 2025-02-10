#!/usr/bin/env bash

ssh-add -l > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "SSH key expired, adding for one minute..."
	ssh-add -t 1m "$HOME/.ssh/id_ed25519" 2>/dev/null
fi
