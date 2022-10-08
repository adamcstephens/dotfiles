{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../apps/dunst
    ../../apps/eww
    ../../apps/gammastep
    ../../apps/kanshi
    ../../apps/swayidle
  ];

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.river

    # pkgs.cider
    pkgs.material-design-icons
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    pkgs.bluez
    pkgs.light
    pkgs.networkmanagerapplet

    # audio
    pkgs.wireplumber

    # apps
    inputs'.webcord.packages.default
  ];

  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };

  home.activation.dotfiles-bootstrap-linux-gui = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    pushd ~/.dotfiles
      if [ -e .nixos-managed ]; then
        git pull
      fi
      CONFIG=dotbot.linux-gui.yaml task dotbot
    popd
  '';

  systemd.user.startServices = "sd-switch";
}
