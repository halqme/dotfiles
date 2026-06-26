{pkgs, ...}: {
  home.packages = with pkgs; [
    # Nix
    nil
    nixd
    alejandra
    ## Nix Support
    comma
    # Language
    ## Go
    go
    ## Rust
    rustup
    ## Crystal
    crystal
    crystalline
    ameba-ls
    shards
    ## Nim
    nim
    nimble
    nimlangserver
    # Git/VCS
    gh
    ghq
    jujutsu
    # Shell
    fd
    ripgrep
    jq
    dust
    bottom
    htop
    gat
    ffmpeg
    aria2
    ## Task Runner
    just
    act
    ## Terminal Multiplexer
    tmux
  ];
}
