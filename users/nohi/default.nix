{ pkgs, ... }:

{
  # Home Manager settings
  home.username = "nohi";
  home.homeDirectory = "/home/nohi";

  # Link the configuration to the home directory
  home.stateVersion = "23.11";

  # Packages to install for the user
  home.packages = with pkgs; [
    neovim
    alacritty
    firefox
    git
    # Add other development tools and apps here
  ];

  # Managed dotfiles
  home.file = {
    # Neovim configuration
    #".config/nvim/init.vim".source = ./config/nvim/init.vim;

    # Alacritty configuration
    #".config/alacritty/alacritty.yml".source = ./config/alacritty/alacritty.yml;
  };

  # KDE/Plasma settings can be managed here as well
  # This is an advanced topic, but you can use home.file to place config files
  # or explore options within home-manager for KDE.
  programs.kdeconnect.enable = true;

  # Enable user-level services if needed
  # services.syncthing.enable = true;

  # This allows home-manager to manage itself
  programs.home-manager.enable = true;
}