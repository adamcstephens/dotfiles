{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../apps/vscode
  ];

  home.packages = [
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.mas
    pkgs.pinentry_mac

    pkgs.wireshark
  ];

  home.activation.dotfiles-bootstrap-darwin = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    pushd ~/.dotfiles
      CONFIG=dotbot.Darwin.yaml task dotbot
    popd
  '';
}
