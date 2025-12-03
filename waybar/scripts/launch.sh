#!/bin/bash

# Kill wlogout 
# pkill wlogout

# Kill swaync 
pkill swaync 

# Kill waybar 
killall -9 waybar 

# Activate all dependencies 
waybar & swaync

