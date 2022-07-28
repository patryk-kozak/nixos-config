{ config, lib, pkgs, ... }:

{
  nix.trustedUsers = [ "root" "hackbee" "audio" ];
  nixpkgs.config.allowUnfree = true;
    
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    version = 2;
    enable = true;
    efiSupport = true;
    useOSProber = true;
    devices = [ "nodev" ];
    splashImage = ../../assets/grub-splash.jpg;
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
  networking.hostName = "zeus";
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  time.timeZone = "Europe/Warsaw";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  system = {
    autoUpgrade.enable = false;
    stateVersion = "22.05";
  };
}

