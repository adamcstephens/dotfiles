{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
    ];

  home.packages = [
    pkgs.vscode
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
