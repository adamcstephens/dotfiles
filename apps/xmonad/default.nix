{
  lib,
  pkgs,
  ...
}: {
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

  systemd.user.services.xautolock-session.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.xautolock-session.Unit.PartOf = lib.mkForce ["xserver-session.target"];

  systemd.user.services.xss-lock.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.xss-lock.Unit.PartOf = lib.mkForce ["xserver-session.target"];
}
