{
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
    MODULAR_HOME = "$HOME/.modular"; # Modular Mojo SDK

    # ========================================================================
    # SSH AGENT
    # ========================================================================
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    # ========================================================================
    # TOOL CONFIGURATIONS
    # ========================================================================
    GHQ_ROOT = "$HOME/Projects";
    _ZO_DATA_DIR = "$HOME/.local/share";

    OLLAMA_FLASH_ATTENTION = 1;
    OLLAMA_CONTEXT_LENGTH = 64000;
  };

  home.sessionPath = [
    "$HOME/.local/bin" # Local Packages
    "$HOME/.modular/pkg/packages.modular.com_mojo/bin" # Modular Mojo
    "$HOME/.ghcup/bin" # Haskell GHCup
    "$HOME/.go/bin" # Go binaries
    "$HOME/.bun/bin" # Bun JavaScript runtime
    "$HOME/.moon/bin" # MoonBit
  ];
}
