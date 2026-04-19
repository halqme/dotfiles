{...}: {
  home.username = "hal";
  home.homeDirectory = "/Users/hal";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.file = {
    ".hushlogin".text = "";
    ".gitignore_global".source = ../../config/.gitignore_global;
    ".tmux.conf".source = ../../config/tmux.conf;
    ".vimrc".source = ../../config/vimrc;
    ".config/brew/Brewfile".source = ../../config/Brewfile;
  };

  xdg.configFile = {
    "zsh/.p10k.zsh" = {
      source = ../../config/.p10k.zsh;
    };

    "karabiner" = {
      source = ../../config/karabiner;
    };

    "nvim" = {
      source = ../../config/nvim;
    };

    "wezterm" = {
      source = ../../config/wezterm;
    };

    "ghostty" = {
      source = ../../config/ghostty;
    };

    ".bunfig.toml" = {
      source = ../../config/bunfig.toml;
    };
  };
}
