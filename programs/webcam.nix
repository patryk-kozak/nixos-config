{
  config,
  pkgs,
  latest-nixpkgs,
  ...
}: {
  services.udev.extraRules = let
    camSettings = pkgs.writeShellScript "setup-v4l2.sh" ''
      ${pkgs.v4l-utils}/bin/v4l2-ctl \
        --device $1 \
        --set-fmt-video=width=1920,height=1080,pixelformat=MJPG \ # Set to 1080p
        -p 30 \ # Set to 30 FPS
        --set-ctrl=power_line_frequency=1 \ # Set to 50Hz power line compensation
        --set-ctrl=focus_auto=0 # Disable autofocus
    '';
  in
    ''
      SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", \
        ATTRS{product}=="Elgato FaceCam Pro", RUN="${camSettings} $devnode"
    '';
}