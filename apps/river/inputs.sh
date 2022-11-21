#!/usr/bin/env sh

riverctl list-inputs | grep Magic_Trackpad | sort -u | while read -r trackpad; do
  riverctl input "$trackpad" natural-scroll enabled
  riverctl input "$trackpad" tap-button-map left-right-middle
done

riverctl set-repeat 100 220

riverctl input pointer-1739-52619-SYNA8004:00_06CB:CD8B_Touchpad events disabled
riverctl input pointer-1739-52619-SYNA8004:00_06CB:CD8B_Touchpad natural-scroll enabled
riverctl input pointer-1739-52619-SYNA8004:00_06CB:CD8B_Touchpad tap-button-map left-right-middle
riverctl input pointer-1739:52619:SYNA8004:00_06CB:CD8B_Touchpad middle-emulation disabled

riverctl focus-follows-cursor always || riverctl focus-follows-cursor normal
