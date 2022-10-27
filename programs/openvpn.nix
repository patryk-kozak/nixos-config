{
  config,
  pkgs,
  ...
}: {
  services.openvpn.servers = {
    nordVPN  = { config = '' config /home/$USER/openvpn/nordVPN.conf ''; };
  };
}