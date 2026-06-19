{
  username,
  homeDirectory,
  stateVersion,
  ...
}: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = stateVersion;

  programs.home-manager.enable = true;

  home.file = {
    ".gitignore_global".source = ../../config/.gitignore_global;
    ".tmux.conf".source = ../../config/tmux.conf;
    ".vimrc".source = ../../config/vim/vimrc;
  };

  xdg.configFile = {
    "zsh/.p10k.zsh".source = ../../config/zsh/.p10k.zsh;
    "nvim".source = ../../config/nvim;
    ".bunfig.toml".source = ../../config/bun/bunfig.toml;
  };
}
