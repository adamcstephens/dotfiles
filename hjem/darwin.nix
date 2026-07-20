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

  # TODO automate starting of built-in ssh-agent
  # home.activation.enable-ssh-agent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH
  #
  #   /bin/launchctl start com.openssh.ssh-agent || true
  # '';
}
