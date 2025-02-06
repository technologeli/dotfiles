#!/usr/bin/env bash
test "$(dunstctl is-paused)" = "true" && echo "Muted" || echo "Unmuted"
