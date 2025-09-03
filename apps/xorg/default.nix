{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.colorScheme.palette;

  xsecurelock = pkgs.writeShellScript "xsecurelock" ''
    export XSECURELOCK_COMPOSITE_OBSCURER=0
    export XSECURELOCK_BACKGROUND_COLOR="#${colors.base00}"
    export XSECURELOCK_AUTH_BACKGROUND_COLOR="#${colors.base00}"
    export XSECURELOCK_AUTH_FOREGROUND_COLOR="#${colors.base05}"
    export XSECURELOCK_FONT="${config.dotfiles.gui.font.mono}"
    export XSECURELOCK_PAM_SERVICE=xscreensaver
    export XSECURELOCK_SHOW_DATETIME=true

    ${pkgs.xsecurelock}/bin/xsecurelock
  '';
in
{
  options.dotfiles.gui.xorg = {
    enable = lib.mkEnableOption "Enable xorg resources";

    wm = lib.mkOption {
      type = lib.types.enum [
        "leftwm"
        "xmonad"
      ];
      description = "which xorg window manager to enable";
      default = "xmonad";
    };
  };

  config = lib.mkIf config.dotfiles.gui.xorg.enable {
    home.packages = [
      pkgs.arandr
      pkgs.grobi
      pkgs.lxrandr
      pkgs.maim
      pkgs.xclip
      pkgs.xdotool
      # pkgs.xlayoutdisplay
      pkgs.xorg.xdpyinfo
      pkgs.xorg.xev
    ];

    services.screen-locker = lib.mkIf (!config.dotfiles.gui.insecure) {
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
        After = [ "xserver-session-pre.target" ];
        PartOf = [ "xserver-session.target" ];
      };

      Install = {
        WantedBy = [ "xserver-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xssproxy}/bin/xssproxy";
      };
    };

    systemd.user.services.xautolock-session = lib.mkIf (!config.dotfiles.gui.insecure) {
      Install.WantedBy = lib.mkForce [ "xserver-session.target" ];
      Unit.PartOf = lib.mkForce [ "xserver-session.target" ];
    };

    systemd.user.services.xss-lock = lib.mkIf (!config.dotfiles.gui.insecure) {
      Install.WantedBy = lib.mkForce [ "xserver-session.target" ];
      Unit.PartOf = lib.mkForce [ "xserver-session.target" ];
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

      initExtra = ''
        # cleanup any wayland
        systemctl --user stop wayland-session.target
        systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY

        export SSH_AUTH_SOCK=$(ssh-agent-mgr)
        export PATH=$HOME/.dotfiles/bin:$PATH

        # chrome and vscode use this to find the secret service
        export XDG_CURRENT_DESKTOP=GNOME

        export XDG_SESSION_TYPE=x11

        dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CONFIG_DIRS XDG_DATA_HOME XDG_CONFIG_HOME XDG_STATE_HOME XDG_CACHE_HOME XDG_DATA_DIRS XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_RUNTIME_DIR

        systemctl --user start tray.target
        systemctl --user start xserver-session.target

        touchpadid="$(xinput list | rg "SYNA.*Touchpad" | sort | tail -n 1 | awk '{print $6}' | cut -f 2 -d=)"
        xinput disable "$touchpadid"

        xsetroot -solid "#000000"
        xset r rate 160 80
      '';
    };

    # re-use .xsession as .xinitrc
    home.file.".xinitrc".source = config.home.file.${config.xsession.scriptPath}.source.outPath;
  };
}
