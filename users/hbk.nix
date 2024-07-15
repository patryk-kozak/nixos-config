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
      ignoreShellProgramCheck = true;
      shell = pkgs.lib.mkForce pkgs.zsh;
    #   openssh.authorizedKeys.keyFiles = [
    #     # needs --impure T_T fix it!
    #     /home/hackbee/.ssh/authorized_keys
    #   ];
    };
  };

  virtualisation.docker.enable = true;

  users.groups.hbk = {};

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.hbk = {
    home.packages = with pkgs; [
      latest-nixpkgs.google-chrome
      git
      wget
      nomacs
      (
        latest-nixpkgs.google-cloud-sdk.withExtraComponents [
          latest-nixpkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
        ]
      )
      kubectl
      kustomize
      kubernetes-helm
      k9s
      terraform
      dbeaver-bin
      evince #  Pdf reader
      gnome3.gnome-screenshot
      gnome.gnome-sound-recorder
      preConfiguredVscode
      slack
      spotify
      nixfmt-rfc-style
      vim
      lshw
      gcc
      drawio
      yarn
      python3
      dive
      jq
      unzip
      nodejs_20
      jdk
      v4l-utils
      jetbrains.idea-community
      shfmt
      shellcheck
      discord
    ];

    programs.go.enable = true;

    programs.tmux = {
      enable = true;
      clock24 = true;
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
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

    home.stateVersion = "24.05";
  };
}