#!/usr/bin/env bash

systemctl is-active --quiet openvpn-home && echo "VPN:On" || echo "VPN:Off"
