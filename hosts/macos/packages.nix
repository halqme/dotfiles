{pkgs, ...}: {
  home.packages = with pkgs; [
    # --- Languages & Runtimes ---
    # Nix
    nil
    nixd
    alejandra
    # JavaScript/TypeScript
    nodejs-slim_latest
    nodejs-slim_latest.npm
    pnpm
    # Go
    go
    # Rust
    rustup
    # Crystal
    crystal
    crystalline
    ameba-ls
    shards
    # Nim
    nim
    nimble
    nimlangserver

    # --- Version Control ---
    gh # GitHub CLI
    ghq # Repository manager
    jujutsu # Modern VCS

    # --- CLI Utilities ---
    # Search & Filter
    fd
    ripgrep
    jq
    # System Monitoring
    dust
    bottom
    htop
    # Task & Workflow
    just
    act
    tmux
    # General Utils
    comma
    gat
    ffmpeg
    aria2
    d2
  ];
}
