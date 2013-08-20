#!/bin/bash

# Echoes the volume of the Master ALSA channel

vol=$(amixer get Master,0 | egrep -o '[0-9]{1,3}%')
echo ${vol%[%]}
