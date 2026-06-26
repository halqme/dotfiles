{...}: {
  home.file = {
    ".gitignore_global".source = ../../config/.gitignore_global;
    ".tmux.conf".source = ../../config/tmux.conf;
    ".vimrc".source = ../../config/vim/vimrc;
  };

  xdg.configFile = {
    ".bunfig.toml".source = ../../config/bun/bunfig.toml;
    "ghostty".source = ../../config/ghostty;
    "nvim".source = ../../config/nvim;
    "wezterm".source = ../../config/wezterm;
    "zsh/.p10k.zsh".source = ../../config/zsh/.p10k.zsh;
  };
}
