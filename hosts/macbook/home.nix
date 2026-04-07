{ ... }:

{
  imports = [
    ../../home
    ../../modules/macos/gui/options.nix
    ../../modules/macos/gui/casks.nix
    ../../modules/macos/gui/font.nix
    ../../modules/macos/gui/mas.nix
    ../../modules/macos/gui/brew-sync.nix
    ../../modules/macos/config-files.nix
  ];

  home.username = "hal";
  home.homeDirectory = "/Users/hal";

  home.stateVersion = "26.05";
}