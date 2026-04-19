{pkgs, ...}: {
  # ============================================================================
  # PACKAGES
  # ============================================================================
  # This file defines all system packages installed via home-manager.
  # Packages are organized by category for clarity and maintainability.

  home.packages = with pkgs; [
    # ========================================================================
    # VERSION CONTROL
    # ========================================================================
    gh # GitHub CLI
    ghq # Repository manager
    jujutsu # Modern VCS

    # ========================================================================
    # SHELL & UTILITIES
    # ========================================================================
    comma # Run programs without installing them
    bat # Synta-highlighting cat
    tmux # Terminal multiplexer
    zellij # Modern terminal multiplexer
    _1password-cli
    bitwarden-cli

    # ========================================================================
    # AGENTS
    # ========================================================================
    github-copilot-cli
    kilocode-cli
    pi-coding-agent

    # ========================================================================
    # SEARCH & NAVIGATION
    # ========================================================================
    ripgrep # Fast grep alternative (rg)
    fd # Fast find alternative

    # ========================================================================
    # SYSTEM MONITORING
    # ========================================================================
    dust # Disk usage visualization
    bottom # System resource monitor
    htop # Interactive process viewer

    # ========================================================================
    # TASK RUNNING & AUTOMATION
    # ========================================================================
    just

    # ========================================================================
    # CI/CD
    # ========================================================================
    act # Run GitHub Actions locally

    # ========================================================================
    # PROGRAMMING LANGUAGE RUNTIMES
    # ========================================================================
    go # Go programming language
    rustup # Rust toolchain installer
    nodejs-slim_latest # JavaScript Runtime

    # ========================================================================
    # LANGUAGE SERVERS & DEVELOPMENT TOOLS
    # ========================================================================
    lua-language-server # Lua LSP
    gopls # Go language server
    nil # Nix language server
    nixd # Modern Nix language server
    alejandra # Nix Formatter
    roslyn-ls # C# Language Server

    # ========================================================================
    # PACKAGE MANAGERS
    # ========================================================================
    pnpm # Fast JavaScript package manager
    nodejs-slim_latest.npm # node package manager

    # ========================================================================
    # PYTHON
    # ========================================================================
    uv # Fast Python package installer & resolver

    # ========================================================================
    # BUILD TOOLS & UTILITIES
    # ========================================================================
    jq # JSON query tool
    mas # Mac App Store CLI

    # ========================================================================
    # MEDIA & GRAPHICS
    # ========================================================================
    imagemagick # Image processing suite
    ghostscript #
    ffmpeg # Multimedia framework
    aria2 # Download utility
    d2 # Diagram creation language
  ];
}
