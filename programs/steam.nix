{
  config,
  pkgs,
  ...
}: {
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    steam
  ];
}
