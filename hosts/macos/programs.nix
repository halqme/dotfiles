{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    config = {
      global = {
        log_filter = "^$";
      };
    };
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

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
  # TUI for Git
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };
  # Search
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Fuzzy finder for command line
  };
}
