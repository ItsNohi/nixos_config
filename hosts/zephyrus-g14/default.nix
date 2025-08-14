{ pkgs, ... }:

{
  imports = [
    # Import the disko configuration for this host
    ./disko.nix
  ];

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable LUKS support in initrd
  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-partlabel/disk-main-luks";
  # Get the UUID after first format with: `sudo blkid`

  # Networking
  networking.hostName = "nohi-g14";
  networking.networkmanager.enable = true;

  # Hardware-specific settings for the G14
  # You might need to add specific drivers or kernel modules here
  # For example, for ASUS laptops:
  # services.supergfxctl.enable = true;

  users.users.nohi = {
    isNormalUser = true;
    description = "nohi";
    extraGroups = [ "networkmanager" "wheel" ]; # For network management and sudo access
    shell = pkgs.zsh; # Or another shell like pkgs.bash
  };

  # Import the Home Manager configuration for "nohi"
  home-manager.users.nohi = import ../../users/nohi;

  # Enable the KDE Plasma 6 Desktop Environment
  services.desktopManager.plasma6.enable = true;
  
  # Enable the SDDM Display Manager (login screen)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true; # Prefer Wayland


  # Define secrets that are specific to this host
  # age.secrets.luks_password = {
  #  file = ../../secrets/luks_password.age;
  #  owner = "root";
  #  group = "root";
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Or whatever version you install with
}
