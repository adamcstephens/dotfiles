{pkgs, ...}: {
  # home.username = "astephe9";
  # home.homeDirectory = "/Users/astephe9";
  home.username = "adam";
  home.homeDirectory = "/home/adam";
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
  ];
}
