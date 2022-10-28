{
  config,
  pkgs,
  ...
}: {
  services.openvpn = {
    servers = {
      us = {
        autoStart = false;
        config = '' config /home/hbk/openvpn/nord.ovpn ''; 
      };
    };
  };
}