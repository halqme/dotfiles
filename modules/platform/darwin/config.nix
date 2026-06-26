{...}: {
  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".hushlogin".text = "";
  };

  xdg.configFile = {
    "homebrew/Brewfile".source = ../../config/homebrew/Brewfile;
    "karabiner".source = ../../config/karabiner;
  };
}
