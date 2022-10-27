{
  config,
  pkgs,
  ...
}: {
  services.openvpn.servers = {
    us = { config = '' config /home/$USER/openvpn/us.ovpn.com.ovpn ''; };
  };
}