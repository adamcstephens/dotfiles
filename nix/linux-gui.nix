{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    # pkgs.cider
  ];

  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };

  home.activation.dotfiles-bootstrap-linux-gui = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    pushd ~/.dotfiles
      CONFIG=dotbot.linux-gui.yaml task dotbot
    popd
  '';
}
