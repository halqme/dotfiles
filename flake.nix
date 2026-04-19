{
  description = "Home Manager configuration of hal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-index-database,
    ...
  }: {
    homeConfigurations = {
      "hal" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";
        modules = [
          ./hosts/macos/home.nix
          nix-index-database.homeModules.nix-index
        ];
      };
      "suse" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        modules = [
          ./hosts/linux/home.nix
          nix-index-database.homeModules.nix-index
        ];
      };
    };
  };
}
