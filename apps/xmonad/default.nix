{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.gui.xorg {
    xsession = {
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;

        config = ./xmonad.hs;
      };
    };
  };
}
