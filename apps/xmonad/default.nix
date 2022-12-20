{pkgs, ...}: {
  home.file.".xinitrc".source = ./xinitrc;

  xresources.properties = {
    "Xft.dpi" = 192;
  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      config = ./xmonad.hs;
    };
  };

  services.screen-locker = {
    enable = true;
    xautolock.detectSleep = true;
    inactiveInterval = 15;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
}
