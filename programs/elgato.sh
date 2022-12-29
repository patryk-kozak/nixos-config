#!/usr/bin/env sh
set -xe

DEV_ID=$(ls /dev/v4l/by-id/ | grep -x 'usb-Elgato.*-video-index0')
v4l2-ctl -d /dev/v4l/by-id/$DEV_ID \
    --set-ctrl="exposure_auto=0,zoom_absolute=5,brightness=160,sharpness=1,contrast=1,saturation=28,white_balance_temperature_auto=0,white_balance_temperature=4400"

# /dev/video6 is a v4l2loopback device we want to send signal to
# configured at hosts/${name}/configuration.nix with kernel modules and modProbeConfig
ffmpeg -f v4l2 -input_format yuyv422 -framerate 30 -video_size 1920x1080 \
    -i /dev/v4l/by-id/$DEV_ID \
    -pix_fmt yuyv422 -f v4l2 /dev/video6