# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
#      ./vscode.nix
    ];
  
  nix.trustedUsers = [ "root" "hackbee" "audio" ];
  nixpkgs.config.allowUnfree = true;
    
  time.hardwareClockInLocalTime = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    version = 2;
    enable = true;
    efiSupport = true;
    useOSProber = true;
    devices = [ "nodev" ];
    splashMode = "stretch";
    extraEntries = ''
	menuentry "Reboot" {
	  reboot
	}
	menuentry "Power Off" {
	  halt
	}
    '';
  };
  boot.initrd.luks.devices.nixos = {
    device = "/dev/disk/by-uuid/f1cf2ffc-983a-4bd9-8b73-0f30733a8edd";
    preLVM = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_5_18;
#  boot.extraModulePackages = with config.boot.kernelPackages; [ rtw89 ];

  hardware.bluetooth.enable = true;

  networking.hostName = "zeus"; # Define your hostnamei.
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.xserver = {
  #  enable = true;
  #  layout = "pl";
  #  videoDrivers = [ "nvidia" ];

  #  xkbOptions = "eurosign:e";
  #  displayManager = {
  #    gdm.enable = true;
  #    setupCommands = ''
  #    ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --left-of DP-1
  #    '';
  #  };

  #  windowManager.i3 = {
  #    enable = true;
  #    package = pkgs.i3-gaps;
  #    extraPackages = with pkgs; [
  #      dmenu
  #      feh
  #      polybarFull
  #	betterlockscreen
  #	rofi
  #      i3status
  #    ];
  #  };
 # };

  fonts.fonts = with pkgs; [
    font-awesome_4
    terminus_font
  ];

  #environment.pathsToLink = [ "/libexec" ];
  
  services.thermald.enable = true;  


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
 # hardware.pulseaudio.enable = true;
 # hardware.pulseaudio.support32Bit = true;
 # hardware.pulseaudio.package = pkgs.pulseaudioFull;  

 # hardware.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
 #   sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
 #     ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
 # '';

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  networking.wireless.userControlled.enable = true; 
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    alacritty
    arandr
    wget
    google-chrome
    discord
    slack
    vim
    lshw
    pciutils
    rtw89-firmware 
    google-cloud-sdk
    terraform
    jq
    zoom-us
    git
    gcc
    bash
    zsh
    age
    jetbrains.idea-community
  ];

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  
   
  hardware.cpu.amd.updateMicrocode = true;
  hardware.nvidia = {
    powerManagement.enable = true;
    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    modesetting.enable = true;
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };
    steam = {
      enable = true;
    };
  };

  users.groups.docker = {};
  
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users = { 
    defaultUserShell = pkgs.zsh;
    users.hackbee = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "docker" ];
    };
  };

  home-manager.users.hackbee = {
    home.packages = with pkgs; [
#      preConfiguredVscode
      spotify
      python38
      zip
      unzip
      docker
      bazel_4
      keybase-gui
      kbfs
      keybase
      openvpn
    ];
    gtk = {
	enable = true;
	font.name = "Victor Mono Regular 12";
	theme = {
	  name = "Orchis";
	  package = pkgs.orchis-theme;
	};
    };
    nixpkgs.config.allowUnfree = true;
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        oh-my-zsh = {
 	        enable = true;
	        plugins = [
	          "git"
	        ];
		theme = "pygmalion";
        };
        plugins = [
	  {
	    name = "powerlevel10k";
	    src = pkgs.fetchFromGitHub {
		owner = "romkatv";
		repo = "powerlevel10k";
		rev = "8a676a9157d2b0e00e88d06456ac7317f11c0317";
		sha256 = "0fkfh8j7rd8mkpgz6nsx4v7665d375266shl1aasdad8blgqmf0c";
	    };
	  }
        ];    
      };
      vscode = {
	      enable = true;
	      extensions = with pkgs.vscode-extensions; [
	        yzhang.markdown-all-in-one
	        hashicorp.terraform
	        golang.go
	        redhat.vscode-yaml
	        yzhang.markdown-all-in-one
          bbenoist.nix
	      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-bazel";
            publisher = "BazelBuild";
            version = "0.5.0";
            sha256 = "249412c14dc1e42d9ec4435d36c5847311528161e722661ab38b7f28bb204e3e";
          }
        ];
      };
      git = {
        enable = true;
        userName = "Patryk Kozak";
        userEmail = "thehackbee@gmail.com";
      };
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

