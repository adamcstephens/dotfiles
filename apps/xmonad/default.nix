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
    export XSECURELOCK_FONT="${config.dotfiles.gui.font}"
    export XSECURELOCK_PAM_SERVICE=xscreensaver

    ${pkgs.xsecurelock}/bin/xsecurelock

    # re-run xset to re-apply key repeat settings
    ${pkgs.xorg.xset}/bin/xset r rate 250 50
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
    inactiveInterval = 5;
    lockCmd = xsecurelock.outPath;
    xautolock.extraOptions = [
      "-notify"
      "10"
      "-notifier"
      ''"${pkgs.libnotify}/bin/notify-send --expire-time=9900 --icon=dialog-information 'Locking in 10 seconds'"''
    ];
  };

  systemd.user.services.xautolock-session.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.xautolock-session.Unit.PartOf = lib.mkForce ["xserver-session.target"];

  systemd.user.services.xss-lock.Install.WantedBy = lib.mkForce ["xserver-session.target"];
  systemd.user.services.xss-lock.Unit.PartOf = lib.mkForce ["xserver-session.target"];
}
