# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, latest-nixpkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot = {
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
    
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call v4l2loopback.out ];

    kernelModules = [ "acpi_call" "v4l2loopback" ];

    kernelParams = [
      "acpi_backlight=native"
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=6 card_label="Elgato FaceCam"
    '';
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-05a40eff-e5da-49d3-8ed6-630ebaf562ae".device = "/dev/disk/by-uuid/05a40eff-e5da-49d3-8ed6-630ebaf562ae";
  boot.initrd.luks.devices."luks-05a40eff-e5da-49d3-8ed6-630ebaf562ae".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "athena"; # Define your hostname.

  nix.trustedUsers = ["root" "hbk" "audio"];
  

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.utf8";
    LC_IDENTIFICATION = "pl_PL.utf8";
    LC_MEASUREMENT = "pl_PL.utf8";
    LC_MONETARY = "pl_PL.utf8";
    LC_NAME = "pl_PL.utf8";
    LC_NUMERIC = "pl_PL.utf8";
    LC_PAPER = "pl_PL.utf8";
    LC_TELEPHONE = "pl_PL.utf8";
    LC_TIME = "pl_PL.utf8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  programs = {
    waybar.enable = true;
    qt5ct.enable = true;
    light.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        wf-recorder
        mako # notification daemon
        grim
        #kanshi
        slurp
        alacritty # Alacritty is the default terminal in the config
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
    };
  };

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };

  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    pkgs.coreutils
    pkgs.usbutils
    pkgs.v4l-utils
    pkgs.ffmpeg
    latest-nixpkgs.globalprotect-openconnect
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # TODO: refactor to work-specific configs stored in non-public repository
  services.globalprotect = {
    enable = false;
    csdWrapper = "${latest-nixpkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.rtkit.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system = {
    autoUpgrade.enable = false;
    stateVersion = "22.11";
  };
}
