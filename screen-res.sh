#!/bin/bash

set -e

# Detect screen resolution and map it to wallpaper size keywords.
# Prefers fbset (framebuffer) over xrandr (X11/Wayland) for reliability.

if command -v fbset &> /dev/null; then
	screen=$(sudo fbset 2>/dev/null | awk '/geometry/ {print $2 "x" $3}')
fi

if [[ -z "$screen" ]] && command -v xrandr &> /dev/null; then
	# Parse xrandr output: look for "connected primary" and extract resolution.
	# Resolution may be followed by "+" (position) or space.
	screen=$(xrandr 2>/dev/null | grep " connected primary" | head -n1 | awk '{print $4}' | cut -d+ -f1 | cut -d' ' -f1)
fi

case "$screen" in
	"1920x1080")
		echo "1080p"
		;;
	"3840x2160")
		echo "4k"
		;;
	"2560x1440")
		echo "2k"
		;;
	*)
		# Fallback for unknown or undetected resolutions
		echo "4k"
		;;
esac
