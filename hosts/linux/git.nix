{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "HAL";
        email = "68320771+HALQME@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core.excludesfile = "~/.gitignore_global";
    };
  };

  home.file.".gitignore_global".source = ../../config/.gitignore_global;
}
