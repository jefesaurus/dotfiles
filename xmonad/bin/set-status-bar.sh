#!/bin/bash

# Conky settings in ~/.conkyrc
killall conky
conky

# This is just for the wireless icon
line="--geometry 1x1-0+752"
if [ -n "$1" ]; then
  if [ "$1" -eq "2" ]; then
    #line="--geometry 1x1+3916+1424"
    line="--geometry 1x1-2560+1424"
  fi
  if [ "$1" -eq "3" ]; then
    line="--geometry 1x1-0+1421"
  fi
  if [ "$1" -eq "4" ]; then
    line="--geometry 1x1-0+0"
  fi
fi
killall stalonetray
sleep 1
stalonetray -display :0 \
            --icon-gravity SE \
            --grow-gravity SE \
            --skip-taskbar \
            --kludges fix_window_pos \
            --icon-size 10 \
            --window-strut none \
            --transparent \
            --tint-color black\
            --tint-level 150\
            --window-layer top\
            $line
