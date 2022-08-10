{ config, pkgs, latest-nixpkgs, ... }:

let
  preConfiguredVscode = import ../programs/vscode.nix { 
    inherit config pkgs latest-nixpkgs;
  };
in
{
    users.users = {
      hackbee = {
        isNormalUser = true;
        group = "hackbee";
        extraGroups = [
            "networkmanager" "wheel" "docker"
        ];
        shell = pkgs.lib.mkForce pkgs.zsh;
        openssh.authorizedKeys.keyFiles = [
          /home/hackbee/.ssh/authorized_keys
        ];
      };
    };

    virtualisation.docker.enable = true;

    users.groups.hackbee = {};

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.hackbee = {
        home.file = {
            ".config/gtk-3.0/settings.ini".source = ./.config/gtk-3.0/settings.ini;
            ".config/alacritty/alacritty.yml".source = ./.config/alacritty/alacritty.yml;
            ".config/htop/htoprc".source = ./.config/htop/htoprc;
            ".config/i3/config".source = ./.config/i3/config;
            ".config/polybar/config".source = ./.config/polybar/config;
            ".config/polybar/init.sh".source = ./.config/polybar/init.sh;
            ".config/rofi/config.rasi".source = ./.config/rofi/config.rasi;
            ".config/rofi/monokai.rasi".source = ./.config/rofi/monokai.rasi;
            ".config/discord/settings.json".source = ./.config/discord/settings.json;
        };
    

    home.packages = with pkgs; [
      arandr
      kbfs
      keybase
      go
      wget
      google-chrome
      blueman  # Bluetooth
      evince  #  Pdf reader
      gnome3.gnome-screenshot
      gnome.gnome-sound-recorder
      preConfiguredVscode
      signal-desktop
      slack-dark
      spotify
      vlc
      nixfmt
      vim
      lshw
      pciutils
      rtw89-firmware 
      google-cloud-sdk
      terraform
      jq
      git
      gcc
      (discord.override {
        version = "0.0.18";
        src = latest-nixpkgs.fetchurl {
          url = "https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.tar.gz";
          sha256 = "BBc4n6Q3xuBE13JS3gz/6EcwdOWW57NLp2saOlwOgMI=";
        };
      })
      latest-nixpkgs.zoom-us
      jdk
      # Developing in Python
      (python38.withPackages(ps : with ps; [ 
          ipython
          flake8
          pycodestyle
          setuptools
          virtualenv
        ]
      ))
    ];

    services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = "32x32";
      };
      settings = {
        global = {
          # Display
          follow = "mouse";
          geometry = "300x6-10+30";
          indicate_hidden = "yes";
          transparency = 40;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          frame_color = "#f9f8f5";
          separator_color = "frame";
          sort = "yes";
          idle_threshold = 360;
          # Text
          font = "Hack Regular 8";
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          word_wrap = "yes";
          ignore_newline = "no";      
          stack_duplicates = true;
          # Icons
          icon_position = "left";
          max_icon_size=32;
          # Misc/Advanced
          browser = "Vivaldi";
          startup_notification = true;
          corner_radius = 0;
        };
        urgency_low = {
          background = "#272822";
          foreground = "#f8f8f2";
          frame_color = "#66d9ef";
        };
        urgency_normal = {
          background = "#272822";
          foreground = "#f8f8f2";
          frame_color = "#f4bf75";
        };
        urgency_critical = {
          background = "#272822";
          foreground = "#f8f8f2";
          frame_color = "#f92672";
        };
      };
    };
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