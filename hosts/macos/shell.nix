{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    # Zsh options
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

    # Plugins
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

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';

      repo = ''
        cd $(ghq list --full-path | fzf)
      '';
    };

    shellGlobalAliases = {
      C = "| tee >(pbcopy)";
      G = "| rg";
      L = "| less -R";
      P = "| pbpaste";
      Cloud = "$HOME/Library/CloudStorage/";
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
      d = "docker";
      dc = "docker compose";
      kiro = "kiro-cli";
      orb = "TERM=xterm-256color orb";
      nf = "nix flake";
      nd = "nix develop --command $SHELL";

      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      mkdir = "mkdir -p";
      less = "less -R";
      history = "history -t \"%F %T\"";

      df = "df -h";
      du = "du -h";
      calc = "bc -l";
      datestamp = "date +%Y%m%d%H%M%S";
      ipinfo = "curl ipinfo.io";
      weather = "curl wttr.in";
      untar = "tar -zxvf";
      port = "lsof -i";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };

    initContent = lib.mkMerge [
      (
        lib.mkOrder 500 ''
          [ -x ~/.local/bin/kiro-cli ] && eval "$(~/.local/bin/kiro-cli init zsh pre --rcfile zshrc)"
        ''
      )
      (
        lib.mkOrder 1000 ''
          alias -s {png,jpg,PNG,JPG,jpeg,JPEG}="gat"
          alias -s {ts,js,tsx,jsx,html,md}="bun run"
          alias -s py="python3"
          alias -s python="python3"
          alias -s sh="bash"
          alias -s swift="swift"
          alias -s cr="crystal"

          # Bun completions
          if [ -s "$HOME/.bun/_bun" ]; then
            source "$HOME/.bun/_bun"
          fi

          # Powerlevel10k - theme configuration
          # Load after all other initializations
          if [ -f "$HOME/.config/zsh/.p10k.zsh" ]; then
            source "$HOME/.config/zsh/.p10k.zsh"
          fi
        ''
      )
      (
        lib.mkOrder 1500 ''
          [ -x ~/.local/bin/kiro-cli ] && eval "$(~/.local/bin/kiro-cli init zsh post --rcfile zshrc)"
        ''
      )
    ];
  };
}
