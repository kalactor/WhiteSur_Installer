#!/bin/bash

set -e

# Get resolution from fbset
if command -v fbset &> /dev/null; then
	screen=$(sudo fbset | awk '/geometry/ {print $2 "x" $3}')
else
	screen=$(xrandr | grep " connected primary" | awk '{print $4}' | cut -d+ -f1)
fi

case "$screen" in
    "1920x1080")
        #echo "Your Screen is Full HD."
	echo "1080p"
        ;;
    "3840x2160")
        #echo "Your Screen is 4K."
	echo "4k"
        ;;
    "2560x1440")
        #echo "Your Screen is 2K."
	echo "2k"
        ;;
    *)
        #echo "Can't determine your screen resolution, setting walls to 4K."
	echo "4k"
        ;;
esac
