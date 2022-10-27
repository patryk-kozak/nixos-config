{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  services.tailscale.enable = true;
  
  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };
}
