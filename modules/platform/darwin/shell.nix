{...}: let
  onePasswordAgentSocket = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in {
  programs.zsh = {
    siteFunctions.repo = ''
      cd $(ghq list --full-path | fzf)
    '';

    shellGlobalAliases = {
      C = "| tee >(pbcopy)";
      P = "| pbpaste";
      Cloud = "$HOME/Library/CloudStorage/";
    };

    shellAliases = {
      d = "docker";
      dc = "docker compose";
      orb = "TERM=xterm-256color orb";
      df = "df -h";
      du = "du -h";
      calc = "bc -l";
      datestamp = "date +%Y%m%d%H%M%S";
      ipinfo = "curl ipinfo.io";
      weather = "curl wttr.in";
      port = "lsof -i";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };

    initContent = ''
      # Ensure Nix profiles are present even when macOS shell startup differs.
      path=(
        "$HOME/.nix-profile/bin"
        "$HOME/.nix-profile/home-path/bin"
        "/nix/var/nix/profiles/default/bin"
        $path
      )
      typeset -U path
      export PATH

      export SSH_AUTH_SOCK="${onePasswordAgentSocket}"

      alias -s {ts,js,tsx,jsx,html,md}="bun run"
      alias -s py="python3"
      alias -s python="python3"
      alias -s sh="bash"
      alias -s swift="swift"
      alias -s cr="crystal"

      if [ -s "$HOME/.bun/_bun" ]; then
        source "$HOME/.bun/_bun"
      fi

      if [ -s "$HOME/.vite-plus/env" ]; then
        source "$HOME/.vite-plus/env"
      fi
    '';
  };

  home.file.".config/zsh/.zprofile".force = true;
}
