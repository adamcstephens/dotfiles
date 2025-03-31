{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./core-gui.nix

    ../apps/finicky
    ../apps/karabiner
  ];

  home.packages = [
    pkgs.iproute2mac
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.iftop
    pkgs.mas
    pkgs.openssh
    pkgs.pinentry_mac
    pkgs.trippy

    # for class
    pkgs.nodejs

    inputs.sandbox.packages.${pkgs.system}.m1ddc
  ];

  dotfiles.apps = {
    vscodium.enable = false;
    vscode.enable = false;
  };

  home.activation.enable-ssh-agent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    /bin/launchctl start com.openssh.ssh-agent || true
  '';

  home.sessionVariables = {
    PATH = "$PATH:/nix/var/nix/profiles/default/bin";
  };
}
