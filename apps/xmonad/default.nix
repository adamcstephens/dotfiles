{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.colorScheme.colors;
  xsecurelock = pkgs.writeScript "xsecurelock" ''
    export XSECURELOCK_COMPOSITE_OBSCURER=0
    export XSECURELOCK_BACKGROUND_COLOR="#${colors.base00}"
    export XSECURELOCK_AUTH_BACKGROUND_COLOR="#${colors.base00}"
    export XSECURELOCK_AUTH_FOREGROUND_COLOR="#${colors.base05}"
    export XSECURELOCK_FONT="JetBrainsMono Nerd Font"

    ${pkgs.xsecurelock}/bin/xsecurelock
  '';
in {
  home.file.".xinitrc".source = ./xinitrc;

  xresources.properties = {
    "Xft.dpi" = config.dotfiles.gui.dpi;
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
    lockCmd = xsecurelock.outPath;
  };

  systemd.user.services.xautolock-session.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.xautolock-session.Unit.PartOf = lib.mkForce ["xserver-session.target"];

  systemd.user.services.xss-lock.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.xss-lock.Unit.PartOf = lib.mkForce ["xserver-session.target"];
}
