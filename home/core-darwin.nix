{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./core-gui.nix

    ../apps/finicky
    ../apps/karabiner
  ];

  home.packages = [
    pkgs.darwin.iproute2mac
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.iftop
    pkgs.mas
    pkgs.openssh
    pkgs.pinentry_mac

    # for class
    pkgs.nodejs

    pkgs.element-desktop
    pkgs.libreoffice-bin

    inputs.sandbox.packages.${pkgs.system}.m1ddc
    inputs.sandbox.packages.${pkgs.system}.firefox-profile-switcher-connector
  ];

  home.activation.enable-ssh-agent = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    launchctl start com.openssh.ssh-agent || true
  '';

  home.sessionVariables = {
    PATH = "$PATH:/nix/var/nix/profiles/default/bin";
  };
}
