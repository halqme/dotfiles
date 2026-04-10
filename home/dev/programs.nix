{
  # ============================================================================
  # DEVELOPMENT TOOLS & CLI PROGRAMS
  # ============================================================================
  # This file enables and configures various CLI tools and development
  # programs through home-manager.

  # ============================================================================
  # FILE & TEXT TOOLS
  # ============================================================================
  programs.bat.enable = true; # Syntax-highlighted cat
  programs.ripgrep.enable = true; # Fast grep alternative (rg)

  # ============================================================================
  # SYSTEM MONITORING & UTILITIES
  # ============================================================================
  programs.bottom.enable = true; # System resource monitor

  # ============================================================================
  # ENVIRONMENT & SHELL INTEGRATION
  # ============================================================================
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Use nix-direnv for better Nix support
    enableZshIntegration = true; # Auto-load .envrc when entering directories
    config = {
      global = {
        log_filter = "^$";
      };
    }
    ;
  };

  # ============================================================================
  # FILE LISTING & NAVIGATION
  # ============================================================================
  # Modern ls alternative
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
  # Track and jump to frequently used directories
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  # Fast fuzzy finder for file contents
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================================
  # FUZZY FINDING & SEARCHING
  # ============================================================================
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Fuzzy finder for command line
  };

  # ============================================================================
  # VERSION CONTROL
  # ============================================================================
  programs.jujutsu.enable = true; # Modern VCS (experimental)
  # Interactive git CLI
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================================
  # EDITORS
  # ============================================================================
  # Vim-based text editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # ============================================================================
  # PACKAGE & INDEX MANAGEMENT
  # ============================================================================
  programs.nix-index.enable = true; # Quickly search packages in nixpkgs

  # ============================================================================
  # TERMINAL MULTIPLEXING
  # ============================================================================
  programs.tmux.enable = true; # Terminal multiplexer
  programs.zellij.enable = true; # Modern terminal workspace
}
