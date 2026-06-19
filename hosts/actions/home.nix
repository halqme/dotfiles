{...}: {
  imports = [
    ../../modules/common/base.nix
    ../../modules/common/git.nix
    ../../modules/common/programs.nix
    ../../modules/common/shell.nix
    ./config.nix
    ./packages.nix
  ];
}
