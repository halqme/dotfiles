{ pkgs, lib, ... }:
let
  isDarwin = builtins.hasAttr "stdenv" pkgs && (pkgs.stdenv.isDarwin or false);
in
lib.mkIf isDarwin {
  my.configFiles = {
    karabiner = {
      source = ../../config/karabiner;
      target = "config/karabiner";
    };
  };
}
