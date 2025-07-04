#!/usr/bin/env bash
# Setup UGTABLET Artist Pro 16 (Gen2)
# License: CC-0/Public-Domain license
# author: deevad

# --------------------------------------
# XP-Pen Artist Pro 16 (Gen2)
# --------------------------------------
#xrandr --output HDMI-0 --auto --pos 0x0 --rotate left --output DP-0 --auto --pos 6000x0 --rotate right --output DP-2 --auto --pos 2160x433 --output DP-4 --auto --pos 2800x2593

# Tablet definition
# Identifier obtained using the 'xsetwacom --list' command line
# The tablet appears after installation of the Digimend kernel driver (10 or more)
# And after creating a special rule for Xorg. 
# See blog post on https://www.davidrevoy.com/index.php?tag/hardware for it.
tabletstylus="UGTABLET Artist Pro 16 (Gen2) stylus"
tableteraser="UGTABLET Artist Pro 16 (Gen2) eraser"

# Constrain stylus to use it's own monitor
# Monitor name here (output) is "HDMI-A-0". It was obtained
# using the 'xrandr' command-line. Your might
# be different. 
output="HDMI-A-0"
xsetwacom --set "$tabletstylus" MapToOutput $output
xsetwacom --set "$tableteraser" MapToOutput $output

# Calibration
# Start by reseting calibration to default area
xsetwacom --set "$tabletstylus" ResetArea
# Default area is '0 0 32767 32767'
# You can obtain it with:
# xsetwacom --get "$tabletstylus" Area
# Calibrate your device manually with `xinput_calibrator` after connecting only the Xpen-Pen pro-art
# (Area is "MinX" "MinY" "MaxX" "MaxY"), then tweak manually adding or rmoving +50 here and there to obtain 
# Something pleasing I found:
#xsetwacom set "$tabletstylus" Area 0 0 32767 32767
xsetwacom set "$tabletstylus" Area -100 -25 32639 32761
# 125 45 32810 32792
xsetwacom set "$tableteraser" Area -100 -25 32639 32761

# Pressure Curve:
# a web GUI is available here to tweak it https://linuxwacom.github.io/bezier.html
xsetwacom --set "$tabletstylus" PressureCurve 90 85 15 100

# Configuration data trimming and suppression
# The event of this device are not legion; better to not filter any for sensitivity
# Minimal trimming is also good.
xsetwacom --set "$tabletstylus" Suppress 0 # data pt.s filtered, default is 2, 0-100 (old 4)
xsetwacom --set "$tabletstylus" RawSample 1 # data pt.s trimmed, default is 4, 1-20 (old 1)
