{
  config,
  pkgs,
  latest-nixpkgs,
  ...
}: {
  stdenv.mkDerivation rec {
    builder = writeShellScript "elgato.sh" ''
      DEV_ID=$(ls /dev/v4l/by-id/ | grep -x 'usb-Elgato.*-video-index0')
      v4l2-ctl -d /dev/v4l/by-id/$DEV_ID \
        --set-ctrl="brightness=180,contrast=3,saturation=35,white_balance_temperature_auto=1,power_line_frequency=2,sharpness=1,exposure_auto=2,zoom_absolute=5"
      ffmpeg -f v4l2 -input_format uyvy422 -framerate 60 -video_size 1920x1080 \
        -i /dev/v4l/by-id/$DEV_ID \
        -pix_fmt yuyv422 -f v4l2 /dev/video11
    '';
  }
}