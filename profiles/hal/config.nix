{repoRoot, ...}: {
  home.file = {
    ".gitignore_global".source = repoRoot + /config/.gitignore_global;
    ".tmux.conf".source = repoRoot + /config/tmux.conf;
    ".vimrc".source = repoRoot + /config/vim/vimrc;
  };

  xdg.configFile = {
    ".bunfig.toml".source = repoRoot + /config/bun/bunfig.toml;
    "ghostty".source = repoRoot + /config/ghostty;
    "nvim".source = repoRoot + /config/nvim;
    "wezterm".source = repoRoot + /config/wezterm;
    "zsh/.p10k.zsh".source = repoRoot + /config/zsh/.p10k.zsh;
  };
}
