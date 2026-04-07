{
  my.configFiles = {
    wezterm = {
      source = ../../config/wezterm;
      target = "config/wezterm";
    };

    ghostty = {
      source = ../../config/ghostty;
      target = "config/ghostty";
    };

    nvim = {
      source = ../../config/nvim;
      target = "config/nvim";
    };

    zellij = {
      source = ../../config/zellij;
      target = "config/zellij";
    };

    gh = {
      source = ../../config/gh;
      target = "config/gh";
    };

    vimrc = {
      source = ../../config/vimrc;
      target = ".vimrc";
    };

    tmux = {
      source = ../../config/tmux.conf;
      target = ".tmux.conf";
    };

    latexmkrc = {
      source = ../../config/latexmkrc;
      target = ".latexmkrc";
    };

    p10k = {
      source = ../../config/zsh/.p10k.zsh;
      target = ".p10k.zsh";
    };

    hushlogin = {
      source = null;
      target = ".hushlogin";
      text = "";
      mode = "0644";
    };

    bun = {
      source = ../../config/bunfig.toml;
      target = "config/.bunfig.toml";
    };
  };
}
