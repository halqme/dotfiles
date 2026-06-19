{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    setOptions = [
      "AUTO_PUSHD"
      "HIST_IGNORE_SPACE"
      "HIST_REDUCE_BLANKS"
      "INTERACTIVE_COMMENTS"
      "NO_BEEP"
      "PRINT_EIGHT_BIT"
      "PUSHD_IGNORE_DUPS"
      "RM_STAR_SILENT"
    ];

    history = {
      extended = true;
      ignoreAllDups = true;
      share = true;
      size = 10000;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    siteFunctions.mkcd = ''
      mkdir --parents "$1" && cd "$1"
    '';

    shellGlobalAliases = {
      G = "| rg";
      L = "| less -R";
    };

    shellAliases = {
      ".." = "cd ..";
      "..2" = "cd ../..";
      "~" = "cd ~";

      c = "clear";
      ls = "eza";
      ll = "eza -la";
      lg = "lazygit";
      grep = "rg";
      nf = "nix flake";
      nd = "nix develop --command $SHELL";

      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      mkdir = "mkdir -p";
      less = "less -R";
      history = "history -t \"%F %T\"";
      untar = "tar -zxvf";
    };

    initContent = ''
      alias -s {png,jpg,PNG,JPG,jpeg,JPEG}="gat"

      if [ -f "$HOME/.config/zsh/.p10k.zsh" ]; then
        source "$HOME/.config/zsh/.p10k.zsh"
      fi
    '';
  };
}
