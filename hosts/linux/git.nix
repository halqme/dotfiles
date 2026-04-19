{...}: {
  programs.git = {
    enable = true;
    userName = "HAL";
    userEmail = "68320771+HALQME@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.excludesfile = "~/.gitignore_global";
    };
  };

  home.file.".gitignore_global".source = ../../config/.gitignore_global;
}
