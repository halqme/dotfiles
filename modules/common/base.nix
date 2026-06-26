{
  username,
  homeDirectory,
  stateVersion,
  ...
}: {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = stateVersion;

  programs.home-manager.enable = true;
}
