{
  config,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };
  services.blueman.enable = true;
}
