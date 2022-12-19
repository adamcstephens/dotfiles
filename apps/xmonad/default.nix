{pkgs, ...}: {
  home.file.".xinitrc".source = ./xinitrc;

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        main = xmonad defaultConfig
            { terminal    = "kitty"
            , modMask     = mod4Mask
            , borderWidth = 3
            }
      '';
    };
  };
}
