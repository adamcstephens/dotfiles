{ flake, pkgs, ... }:
{
  imports = [
    ./core.nix
    ./dev.nix
    ./gui.nix

    ../apps/finicky
    ../apps/karabiner
  ];

  packages = [
    pkgs.iproute2mac
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.iftop
    pkgs.mas
    pkgs.pinentry_mac
    pkgs.trippy
    pkgs.xz

    flake.packages.${pkgs.stdenv.hostPlatform.system}.dark-mode
  ];

  dotfiles.apps = {
    zk.enable = true;
  };
}
