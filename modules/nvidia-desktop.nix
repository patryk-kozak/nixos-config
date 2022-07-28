{ config, pkgs, latest-nixpkgs, ... }:

{
  services.xserver = {
    # Enable propriatary drivers
    videoDrivers = [
      "amdgpu" "nvidia"
    ];

    enable = true;
    layout = "pl";

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
      };
    };

    displayManager.gdm = {
      wayland = false;
      enable = true;
    };
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        feh
        betterlockscreen
        polybarFull
        rofi
      ];
    };  
  };

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

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [
      "video=DP-2:2560x1440@144"
      "video=eDP-1:2560x1440@144"
    ];
  };

  fonts.fonts = with pkgs; [
    font-awesome_4
    terminus_font
    powerline-fonts
    (latest-nixpkgs.nerdfonts.override { 
      fonts = ["Hack"]; 
    })
  ];
  
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # NetworkManager in Gnome
    alacritty # Cool rust terminal
    pavucontrol # PulseAudio Volume Control
    arandr # Front End for xrandr
    brightnessctl # Control screen brightness
  ];
}