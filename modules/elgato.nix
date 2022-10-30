{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.gphoto2
  ];

  boot = {
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label=a7III
    '';
  };
}