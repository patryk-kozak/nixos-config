{
  config,
  pkgs,
  ...
}: {  
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };
}