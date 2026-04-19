{pkgs, ...}: {
  home.packages = with pkgs; [
    git
    curl
    vim
    tmux
    ripgrep
  ];
}
