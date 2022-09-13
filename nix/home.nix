{pkgs, ...}: {
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.alejandra
    pkgs.htop
  ];
}
