{
  config,
  lib,
  pkgs,
  ...
}: {
  home.activation.fix-mimeapps = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    export PATH="$PATH:${lib.makeBinPath [pkgs.alejandra pkgs.gnused pkgs.ripgrep]}"
    export HOME="${config.home.homeDirectory}"

    ${./switch-cleanup.sh}
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = import ./default-applications.nix;
  };
}
