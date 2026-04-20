{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    enableVteIntegration = true;

    # Zsh options
    setOptions = [
      "AUTO_PUSHD"
      "CD_PATH"
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
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" &amp;&amp; cd "$1"
      '';
    };

    shellGlobalAliases = {
      C = "| tee >(pbcopy)";
      G = "| rg";
      L = "| less";
      N = "; notify";
      P = "| pbpaste";
      Cloud = "$HOME/Library/CloudStorage/";
    };

    shellAliases = {
      ".." = "cd ..";
      "..2" = "cd ../..";
      "..3" = "cd ../../..";
      "~" = "cd ~";
      repo = "local repodir=$(ghq list | fzf -1 +m) && cd $(ghq root)/$repodir";

      c = "clear";
      ls = "eza";
      ll = "eza -la";
      lg = "lazygit";
      grep = "rg";
      glor = "glow -p";
      d = "docker";
      dc = "docker compose";
      mp = "multipass";
      q = "kiro-cli";
      kiro = "kiro-cli";
      orb = "TERM=xterm-256color orb";
      nf = "nix flake";
      nd = "nix develop --command $SHELL";

      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      mkdir = "mkdir -p";
      history = "history -t \"%F %T\"";

      df = "df -h";
      du = "du -h";
      calc = "bc -l";
      datestamp = "date +%Y%m%d%H%M%S";
      ipinfo = "curl ipinfo.io";
      weather = "curl wttr.in";
      speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -";
      untar = "tar -zxvf";
      port = "lsof -i";

      brew-backup = "brew bundle dump --force --file ~/.config/home-manager/hosts/macbook/config/Brewfile --describe";
      gh-copilot = "COPILOT_MODEL=gpt-5-mini copilot";
      gptk = "gameportingtoolkit-no-hud ~/$MY_GAME_PREFIX";
      pdftohtml = "pdftohtml -enc UTF-8 -noframes";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      yt-dlp-f = "yt-dlp --no-check-certificate";
      zj = "zellij attach default || zellij --session default";
    };

    initContent = ''
      alias -s {png,jpg,PNG,JPG,jpeg,JPEG}="imgcat"
      alias -s {ts,js,tsx,jsx,html}="bun run"
      alias -s py="python3"
      alias -s python="python3"
      alias -s sh="bash"
      alias -s swift="swift"
      alias -s md="glow -p"

      # Load 1Password CLI completions and integrations
      if [ -f "$HOME/.config/op/plugins.sh" ]; then
        source "$HOME/.config/op/plugins.sh"
      fi

      # Bun completions
      if [ -s "$HOME/.bun/_bun" ]; then
        source "$HOME/.bun/_bun"
      fi

      # Powerlevel10k - theme configuration
      # Load after all other initializations
      if [ -f "$HOME/.config/zsh/.p10k.zsh" ]; then
        source "$HOME/.config/zsh/.p10k.zsh"
      fi
    '';
  };
}
