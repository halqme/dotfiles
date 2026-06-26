{...}: {
  imports = [
    ../../modules/common/base.nix
    ../../modules/platform/darwin/config.nix
    ../../modules/platform/darwin/git.nix
    ../../modules/platform/darwin/homebrew.nix
    ../../modules/platform/darwin/shell.nix
    ../../profiles/hal/home.nix
    ./ssh.nix
  ];
}
