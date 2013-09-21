#!/bin/bash

# Echoes the volume of the Master ALSA channel

muted=$(amixer get Master,0 | egrep -oE '\[off\]')
if [[ -n $muted ]]; then
	echo 1
else
	echo 0
fi
