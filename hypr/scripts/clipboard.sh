#!/bin/sh
selection="$(cliphist list | rofi -dmenu -display-columns 2)"
echo "$selection" | cliphist decode | wl-copy

