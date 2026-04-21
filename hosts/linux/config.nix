{...}: {
  home.username = "hal";
  home.homeDirectory = "/home/hal";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  xdg.configFile = {
    "zsh" = {
      source = ../../config/zsh;
    };


    ".bunfig.toml" = {
      source = ../../config/bun/bunfig.toml;
    };
  };
}
