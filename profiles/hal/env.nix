{
  home.sessionVariables = {
    BUN_INSTALL = "$HOME/.bun";
    DENO_HOME = "$HOME/.deno";
    PNPM_HOME = "$HOME/.pnpm";

    GOPATH = "$HOME/.go";
    MODULAR_HOME = "$HOME/.modular";

    GHQ_ROOT = "$HOME/Projects";
    _ZO_DATA_DIR = "$HOME/.local/share";

    OLLAMA_FLASH_ATTENTION = 1;
    OLLAMA_CONTEXT_LENGTH = 64000;
  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "/etc/profiles/per-user/$USER/bin"
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.local/bin"
    "$HOME/.modular/pkg/packages.modular.com_mojo/bin"
    "$HOME/.ghcup/bin"
    "$HOME/.go/bin"
    "$HOME/.pnpm/bin"
    "$HOME/.bun/bin"
    "$HOME/.deno/bin"
    "$HOME/.moon/bin"
    "$HOME/.lmstudio/bin"
  ];
}
