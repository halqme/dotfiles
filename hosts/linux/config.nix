{...}: {
  home.username = "hal";
  home.homeDirectory = "/home/hal";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  xdg.configFile = {
    "zsh/.p10k.zsh" = {
      source = ../../config/zsh/.p10k.zsh;
    };


    ".bunfig.toml" = {
      source = ../../config/bun/bunfig.toml;
    };
  };
}
