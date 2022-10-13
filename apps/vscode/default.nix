{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.vscode
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
