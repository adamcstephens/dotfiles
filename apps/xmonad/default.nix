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
    export XSECURELOCK_SHOW_DATETIME=true

    ${pkgs.xsecurelock}/bin/xsecurelock
  '';
in {
  imports = [
    ../xautocfg
  ];

  home.file.".xinitrc".source = ./xinitrc;

  home.packages = [
    pkgs.maim
    pkgs.xdotool
  ];

  services.screen-locker = lib.mkIf (! config.dotfiles.gui.insecure) {
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

  systemd.user.services.xssproxy = {
    Unit = {
      Description = "forward freedesktop.org Idle Inhibition Service calls to Xss";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install = {WantedBy = ["graphical-session.target"];};

    Service = {
      ExecStart = "${pkgs.xssproxy}/bin/xssproxy";
    };
  };

  systemd.user.services.xautolock-session = lib.mkIf (! config.dotfiles.gui.insecure) {
    Install.WantedBy = lib.mkForce ["xserver-session.target"];
    Unit.PartOf = lib.mkForce ["xserver-session.target"];
  };

  systemd.user.services.xss-lock = lib.mkIf (! config.dotfiles.gui.insecure) {
    Install.WantedBy = lib.mkForce ["xserver-session.target"];
    Unit.PartOf = lib.mkForce ["xserver-session.target"];
  };

  xdg.desktopEntries = {
    xprop = {
      name = "xprop";
      exec = "${pkgs.systemd}/bin/systemd-cat --identifier=xprop ${lib.getExe pkgs.xorg.xprop}";
    };
  };

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

    initExtra = ''
      systemctl --user start xserver-session.target
      systemctl --user start tray.target

      export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh

      touchpadid="$(xinput list | rg "SYNA.*Touchpad" | sort | tail -n 1 | awk '{print $6}' | cut -f 2 -d=)"
      xinput disable "$touchpadid"

      if [ "$(hostname)" = "blank" ]; then
        xset -dpms
      fi
    '';
  };
}
