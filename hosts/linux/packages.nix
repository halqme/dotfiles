{pkgs, ...}: {
  home.packages = with pkgs; [
    aria2 # downloader
    ripgrep # grep replacement
    htop # top replacement
    bottom # process monitor
  ];
}
