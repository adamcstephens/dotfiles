{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../apps/kitty
    ../apps/finicky
    ../apps/karabiner
    ../apps/vscode
  ];

  home.packages = [
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.iftop
    pkgs.mas
    pkgs.pinentry_mac

    # for class
    pkgs.nodejs

    pkgs.element-desktop

    inputs.sandbox.packages.${pkgs.system}.m1ddc
  ];

  home.activation.enable-ssh-agent = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    launchctl start com.openssh.ssh-agent
  '';
}
