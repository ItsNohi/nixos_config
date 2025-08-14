{
  description = "Base Configuration for Nohi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, disko, agenix, home-manager, ...}@inputs: {
    nixosConfigurations = {
      zephyrus-g14 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs; };
        modules = [
          ./hosts/zephyrus-g14

          ./modules/nixos/base.nix

          inputs.disko.nixosModules.disko
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}