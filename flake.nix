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
  }: let
    mkHome = system: homeModule:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          homeModule
          nix-index-database.homeModules.nix-index
        ];
      };
  in {
    homeConfigurations = {
      "hal@MacBook-Pro-M4" = mkHome "aarch64-darwin" ./hosts/macos/home.nix;
      "ci@actions" = mkHome "x86_64-linux" ./hosts/linux/home.nix;
    };
  };
}
