{...}: let
  gitEmail = "68320771+HALQME@users.noreply.github.com";
  gitSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICo87LAYNrYhv5xPCLFgZedT+hBWUBMJrG3WLW6GFnfM";
in {
  programs.git.enable = true;
  programs.git.settings = {
    user.signingKey = gitSigningKey;

    core = {
      fsmonitor = true;
      untrackedCache = true;
    };

    branch.sort = "-committerdate";
    tag.sort = "version:refname";

    diff = {
      algorithm = "histogram";
      colorMoved = "plain";
      mnemonicPrefix = true;
      renames = true;
    };

    merge = {
      conflictStyle = "zdiff3";
      "our".driver = true;
    };

    push = {
      default = "simple";
      autoSetupRemote = true;
      followTags = true;
    };

    fetch = {
      prune = true;
      pruneTags = true;
      all = true;
    };

    commit = {
      verbose = true;
      gpgSign = true;
    };

    tag.gpgSign = true;

    rebase = {
      autoSquash = true;
      autoStash = true;
      updateRefs = true;
    };

    help.autocorrect = "prompt";

    rerere = {
      enabled = true;
      autoupdate = true;
    };

    gpg = {
      format = "ssh";
      ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    filter.lfs = {
      required = true;
      clean = "git-lfs clean -- %f";
      smudge = "git-lfs smudge -- %f";
      process = "git-lfs filter-process";
    };

    url."https://".insteadOf = "git://";

    alias = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit -m";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
    };
  };

  home.file.".ssh/allowed_signers".text = "${gitEmail} ${gitSigningKey}\n";
}
