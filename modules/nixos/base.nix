# /etc/nixos/modules/nixos/base.nix
#
# This file defines the base configuration that should be applied to all hosts.
{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and the new command-line interface
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Basic networking setup
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
  ];

  # Enable the OpenSSH server.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid password authentication and only allow key-based authentication
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Example of enabling a service
  # services.printing.enable = true;

  # Set the default shell for users
  # users.defaultUserShell = pkgs.zsh;

  # This is a good place for system-wide fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
  ];

}