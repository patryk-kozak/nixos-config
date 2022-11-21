#!/usr/bin/env sh
set -xe
sudo modprobe v4l2loopback video_nr=10 card_label='ElGato FaceCam' exclusive_caps=1

DEV_ID=$(ls /dev/v4l/by-id/ | grep -x 'usb-Elgato.*-video-index0')
v4l2-ctl -d /dev/v4l/by-id/$DEV_ID \
    --set-ctrl="exposure_auto=0,zoom_absolute=6,brightness=160,sharpness=1,contrast=1,saturation=28,white_balance_temperature_auto=0,white_balance_temperature=4300"
ffmpeg -f v4l2 -input_format yuyv422 -framerate 60 -video_size 1920x1080 \
    -i /dev/v4l/by-id/$DEV_ID \
    -pix_fmt yuyv422 -f v4l2 /dev/video10