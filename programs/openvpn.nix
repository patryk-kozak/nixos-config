{
  config,
  pkgs,
  ...
}: {
  services.openvpn.servers = {
    us = { config = '' config /home/hbk/openvpn/us.ovpn.com.ovpn ''; };
  };
}