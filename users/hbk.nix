{
  config,
  pkgs,
  latest-nixpkgs,
  ...
}: let
  preConfiguredVscode = import ../programs/vscode.nix {
    inherit config pkgs latest-nixpkgs;
  };
in {
  users.users = {
    hbk = {
      isNormalUser = true;
      group = "hbk";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      shell = pkgs.lib.mkForce pkgs.zsh;
    #   openssh.authorizedKeys.keyFiles = [
    #     # needs --impure T_T fix it!
    #     /home/hackbee/.ssh/authorized_keys
    #   ];
    };
  };

  virtualisation.docker.enable = true;

    users.groups.hackbee = {};

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.hackbee = {
    home.packages = with pkgs; [
      vscode
      google-chrome
      git
      evince #  Pdf reader
      gnome3.gnome-screenshot
      gnome.gnome-sound-recorder
      preConfiguredVscode
      slack
      teams
      spotify
      nixfmt
      vim
      lshw
      gcc
      jdk
      (discord.override {
        version = "0.0.18";
        src = latest-nixpkgs.fetchurl {
          url = "https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.tar.gz";
          sha256 = "BBc4n6Q3xuBE13JS3gz/6EcwdOWW57NLp2saOlwOgMI=";
        };
      })
    ];

    programs.tmux = {
      enable = true;
      clock24 = true;
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;

      shellAliases = {};

      oh-my-zsh = {
        enable = true;
        plugins = [
          "fd"
          "git"
          "kubectl"
          "ripgrep"
        ];
        theme = "pygmalion";
      };
    };
  };
}