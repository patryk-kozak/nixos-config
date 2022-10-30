{
  description = "Patryk Kozak NixOS";

  inputs = {
    # Nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    latest-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, latest-nixpkgs, home-manager,
    #sops-nix,
    flake-utils-plus, alejandra, ... }@inputs:
    let
      gen-extra-args = system: {
        latest-nixpkgs = import latest-nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      };
    in flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [
        "x86_64-linux"
      ];

      channelsConfig = { allowUnfree = true; };

      # Host defaults
      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = gen-extra-args "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages =
              [ alejandra.defaultPackage.x86_64-linux ];
          }
        ];
      };

      hosts = {
        athena = {
          modules = [
            ./hosts/athena/hardware-configuration.nix
            ./hosts/athena/configuration.nix
            ./modules/bluetooth.nix
            ./modules/pipewire.nix
            ./modules/openvpn.nix
            ./modules/elgato.nix
            ./users/hbk.nix
            ./programs/steam.nix
            # ./programs/tailscale.nix
          ];
        };
      };
    };
}
