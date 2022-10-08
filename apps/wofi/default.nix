{pkgs, ...}: {
  xdg.configFile."wofi/wofi.conf".source = ./wofi.conf;
  xdg.configFile."wofi/wofi.css".source = ./wofi.css;

  home.packages = [
    pkgs.wofi
  ];
}
