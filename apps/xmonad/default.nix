{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.dotfiles.gui.xorg.enable && config.dotfiles.gui.xorg.wm == "xmonad") {
    xsession = {
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;

        config = ./xmonad.hs;
      };
    };
  };
}
