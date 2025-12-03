#!/usr/bin/env bash

brightnessctl set 5%- -q
brightnessctl get | awk -v max=$(brightnessctl max) '{printf "%d", ($1/max)*100}' | wob

