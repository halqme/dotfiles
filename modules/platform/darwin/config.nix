{repoRoot, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".hushlogin".text = "";
  };

  xdg.configFile = {
    "homebrew/Brewfile".source = repoRoot + /config/homebrew/Brewfile;
    "karabiner".source = repoRoot + /config/karabiner;
  };
}
