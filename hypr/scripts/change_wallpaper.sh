#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Extract the current wallpaper path only
CURRENT_WALL=$(hyprctl hyprpaper listloaded | grep -E '^/')

# Pick a random wallpaper different from current
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | grep -v "$CURRENT_WALL" | shuf -n 1 | tr -d '\0')

# Get monitor name
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')

# Unload the old wallpaper 
hyprctl hyprpaper unload "$CURRENT_WALL"

# Generate themes based on current wallpaper using matugen 
matugen --config=$HOME/.config/matugen/config.toml image "$WALLPAPER"

# Preload the new wallpaper
hyprctl hyprpaper preload "$WALLPAPER"

# Set the new wallpaper
hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"

