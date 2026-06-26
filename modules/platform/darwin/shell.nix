{...}: {
  programs.zsh = {
    shellGlobalAliases = {
      C = "| tee >(pbcopy)";
      P = "| pbpaste";
      Cloud = "$HOME/Library/CloudStorage/";
    };

    shellAliases = {
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

      export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  home.file.".config/zsh/.zprofile".force = true;
}
