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

    # --- Version Control ---
    gh # GitHub CLI
    ghq # Repository manager
    jujutsu # Modern VCS
    lazygit # Git TUI

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
    ffmpeg
    aria2
    d2
    bitwarden-cli

    # --- Agents & Specialized Tools ---
    kilocode-cli

    # --- GUI Apps (Open Source / CLI-based) ---
    beekeeper-studio
    iina
    audacity
    vscode
    motrix-next
  ];
}
