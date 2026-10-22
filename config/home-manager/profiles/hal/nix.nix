{pkgs, lib, ...}: let
  nixPathDarwin = lib.optionalString pkgs.stdenv.isDarwin ''
    # Ensure Nix profiles are present even when macOS shell startup differs.
    path=(
      "$HOME/.nix-profile/bin"
      "/nix/var/nix/profiles/default/bin"
      $path
    )
    typeset -U path
    export PATH
  '';
in {
  home.packages = with pkgs; [
    comma
    nil
    nixd
    alejandra
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    config.global.log_filter = "^$";
    nix-direnv = {
      enable = true;
    };

    stdlib = ''
      use_age() {
        local encrypted_file="''${1:-.env.age}"
        local tmp_file
        local status

        [ -f "$encrypted_file" ] || return 0

        watch_file "$encrypted_file"
        tmp_file="$(mktemp)"

        if ! ${pkgs.age}/bin/age \
          --decrypt \
          -i "$HOME/.config/age/identity.age" \
          "$encrypted_file" \
          > "$tmp_file"
        then
          rm -f "$tmp_file"
          return 1
        fi

        dotenv "$tmp_file"
        status=$?

        rm -f "$tmp_file"
        return "$status"
      }
    '';
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = false;
  };

  xdg.configFile."zsh/nix-env.zsh".text = ''
    ${nixPathDarwin}
    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

    if [ -f "$HOME/.nix-profile/etc/profile.d/command-not-found.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/command-not-found.sh"
    fi
  '';
}
