{...}: let
  gitEmail = "68320771+HALQME@users.noreply.github.com";
in {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "HAL";
        email = gitEmail;
      };

      core = {
        excludesfile = "~/.gitignore_global";
        editor = "nvim";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
