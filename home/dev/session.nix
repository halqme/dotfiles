{
  # ============================================================================
  # SESSION VARIABLES & PATH CONFIGURATION
  # ============================================================================
  # This file configures environment variables and PATH entries for the shell
  # session. Variables are organized by tool/purpose for clarity.

  home.sessionVariables = {
    # ========================================================================
    # PACKAGE MANAGERS & BUILD TOOLS
    # ========================================================================
    BUN_INSTALL = "$HOME/.bun"; # Bun JavaScript runtime
    PNPM_HOME = "$HOME/.pnpm"; # PNPM package manager cache

    # ========================================================================
    # LANGUAGE RUNTIMES & SDKS
    # ========================================================================
    GOPATH = "$HOME/.go"; # Go workspace path
    DOTNET_ROOT = "/usr/local/share/dotnet"; # .NET SDK location
    MODULAR_HOME = "$HOME/.modular"; # Modular Mojo SDK
  };

  home.sessionPath = [
    "$HOME/.local/bin" # Local Packages
    "$HOME/.modular/pkg/packages.modular.com_mojo/bin" # Modular Mojo
    "$HOME/.ghcup/bin" # Haskell GHCup
    "$HOME/.go/bin" # Go binaries
    "$HOME/.bun/bin" # Bun JavaScript runtime
    "$HOME/.moon/bin" # MoonBit

    "/usr/local/share/dotnet" # .NET SDK binaries
  ];
}
