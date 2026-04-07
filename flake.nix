{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    homeConfigurations = {
      "hal" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/macbook/home.nix
          nix-index-database.homeModules.nix-index
        ];
      };
    };
  };
}
