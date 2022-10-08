{pkgs, ...}: {
  xdg.configFile."wofi/config".source = ./config;
  xdg.configFile."wofi/style.css".source = ./style.css;

  home.packages = [
    pkgs.wofi
  ];
}
