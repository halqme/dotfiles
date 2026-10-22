{
  description = "Home Manager configuration of hal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-index-database,
    ...
  }: {
    homeConfigurations = import ./lib/mk-home-configurations.nix {
      repoRoot = ./.;
      homeDefinitions = {
        "hal@macbook-pro-m4.local" = {
          system = "aarch64-darwin";
          homeDirectory = "/Users/hal";
          modules = [./hosts/macbook/home.nix];
        };
        "ci@actions" = {
          system = "x86_64-linux";
          homeDirectory = "/home/hal";
          modules = [./hosts/actions/home.nix];
        };
      };
      inherit home-manager nix-index-database nixpkgs;
    };

    checks = nixpkgs.lib.genAttrs ["aarch64-darwin" "x86_64-linux"] (system:
      import ./tests {
        pkgs = nixpkgs.legacyPackages.${system};
        repoRoot = ./.;
        inherit (self) homeConfigurations;
        inherit home-manager nix-index-database nixpkgs;
      });
  };
}
