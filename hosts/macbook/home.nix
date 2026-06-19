{...}: {
  imports = [
    ../../modules/common/base.nix
    ../../modules/common/git.nix
    ../../modules/common/programs.nix
    ../../modules/common/shell.nix
    ../../modules/platform/darwin/git.nix
    ../../modules/platform/darwin/homebrew.nix
    ../../modules/platform/darwin/programs.nix
    ../../modules/platform/darwin/shell.nix
    ./config.nix
    ./env.nix
    ./packages.nix
    ./ssh.nix
  ];

  xdg.enable = true;
}
