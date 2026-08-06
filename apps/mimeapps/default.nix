{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.activation.fix-mimeapps = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    export PATH="$PATH:${
      lib.makeBinPath [
        pkgs.gnused
        pkgs.ripgrep
      ]
    }"
    export HOME="${config.directory}"

    ${./switch-cleanup.sh}
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = import ./default-applications.nix;
  };
}
