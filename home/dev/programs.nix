{
  # ============================================================================
  # DEVELOPMENT TOOLS & CLI PROGRAMS
  # ============================================================================
  # This file enables and configures various CLI tools and development
  # programs through home-manager.

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

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
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
    defaultEditor = false;
  };
  # Helix Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
      editor = {
        line-number = "relative";
        middle-click-paste = false;
        mouse = true;
        true-color = true;
        popup-border = "popup";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        lsp = {
          display-messages = true;
        };
      };
    };
  };
}
