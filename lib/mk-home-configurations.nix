{
  repoRoot,
  homeDefinitions,
  home-manager,
  nix-index-database,
  nixpkgs,
}: let
  lib = nixpkgs.lib;
  defaultStateVersion = "26.05";

  parseConfigName = name: let
    match = builtins.match "([^@]+)@(.+)" name;
  in
    if match == null
    then throw "Invalid home configuration name: ${name}"
    else {
      username = builtins.elemAt match 0;
      hostname = builtins.elemAt match 1;
    };

  mkHome = {
    system,
    hostname,
    username,
    homeDirectory,
    stateVersion,
    modules,
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit
          system
          hostname
          username
          homeDirectory
          repoRoot
          stateVersion
          ;
      };
      modules =
        [
          nix-index-database.homeModules.nix-index
        ]
        ++ modules;
    };

  mkNamedHome = name: config:
    mkHome ({
        inherit (parseConfigName name) hostname username;
        stateVersion = defaultStateVersion;
      }
      // config);
in
  lib.mapAttrs mkNamedHome homeDefinitions
