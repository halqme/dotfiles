{pkgs, ...}: {
  home.packages = with pkgs; [
    # Global Language Support
    ## Nix
    nil
    nixd
    alejandra

    ## JavaScript/TypeScript
    nodejs-slim_latest
    nodejs-slim_latest.npm
    pnpm

    ## C#
    roslyn-ls

    ## Go
    go

    ## Rust
    rustup

    # Version Control
    gh # GitHub CLI
    ghq # Repository manager
    jujutsu # Modern VCS
    lazygit

    # Tools
    ## Search
    fd
    ripgrep
    ## System Monitoring
    dust
    bottom
    htop
    ## Task runnner
    just
    act
    ## utils
    comma
    bat
    tmux
    bitwarden-cli
    jq
    ffmpeg
    aria2
    d2

    # Agents
    kilocode-cli

    # GUI Apps
    bitwarden-desktop
    beekeeper-studio
  ];
}
