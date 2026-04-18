{ pkgs, ... }:

{
  # ============================================================================
  # PACKAGES
  # ============================================================================
  # This file defines all system packages installed via home-manager.
  # Packages are organized by category for clarity and maintainability.

  home.packages = with pkgs; [
    # ========================================================================
    # VERSION CONTROL
    # ========================================================================
    delta # Syntax-highlighting diff viewer
    gh # GitHub CLI
    ghq # Repository manager

    # ========================================================================
    # SHELL & UTILITIES
    # ========================================================================
    comma # Run programs without installing them
    _1password-cli
    bitwarden-cli

    # ========================================================================
    # AGENTS
    # ========================================================================
    kiro-cli
    copilot-cli

    # ========================================================================
    # SEARCH & NAVIGATION
    # ========================================================================
    ripgrep # Fast grep alternative (rg)
    fd # Fast find alternative

    # ========================================================================
    # SYSTEM MONITORING
    # ========================================================================
    dust # Disk usage visualization
    htop # Interactive process viewer

    # ========================================================================
    # TASK RUNNING & AUTOMATION
    # ========================================================================
    just

    # ========================================================================
    # DOCUMENTATION & MARKUP
    # ========================================================================
    glow # Markdown viewer
    marksman # Markdown language server

    # ========================================================================
    # CI/CD
    # ========================================================================
    act# Run GitHub Actions locally

    # ========================================================================
    # PROGRAMMING LANGUAGE RUNTIMES
    # ========================================================================
    go # Go programming language
    rustup # Rust toolchain installer
    bun # Bun JavaScript runtime
    nodejs-slim_latest

    # ========================================================================
    # LANGUAGE SERVERS & DEVELOPMENT TOOLS
    # ========================================================================
    lua-language-server # Lua LSP
    gopls # Go language server
    nil # Nix language server
    nixd # Modern Nix language server
    alejandra

    # ========================================================================
    # PACKAGE MANAGERS
    # ========================================================================
    pnpm # Fast JavaScript package manager

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
