#!/usr/bin/env sh
set -xe

DEV_ID=$(ls /dev/v4l/by-id/ | grep -i -E "facecam.+index0")
v4l2-ctl -d /dev/v4l/by-id/$DEV_ID \
    --set-ctrl="exposure_auto=0,zoom_absolute=6,brightness=160,sharpness=1,contrast=1,saturation=28,white_balance_temperature_auto=0,white_balance_temperature=4300"
ffmpeg -debug -input_format uyvy422 \
    -i /dev/video6  -framerate 60 \
    -pix_fmt yuyv422 -f v4l2 /dev/video6