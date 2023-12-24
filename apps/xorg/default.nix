{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  colors = config.colorScheme.colors;

  wallpaper = inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
    logoSize = 12;
    backgroundColor = "#${colors.base00}";
    logoColors = {
      color0 = "#${colors.base08}";
      color1 = "#${colors.base0A}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0C}";
      color4 = "#${colors.base0E}";
      color5 = "#${colors.base0F}";
    };
  };

  xsecurelock = pkgs.writeScript "xsecurelock" ''
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
  config = lib.mkIf config.dotfiles.gui.xorg.enable {
    home.packages = [
      pkgs.maim
      pkgs.xdotool
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
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
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
        systemctl --user start xserver-session.target
        systemctl --user start tray.target

        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
        if [ -S "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock" ]; then
          export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock
        fi

        # unfortunately these are mutually exclusive
        /run/current-system/sw/bin/systemctl --user unset-environment WAYLAND_DISPLAY

        touchpadid="$(xinput list | rg "SYNA.*Touchpad" | sort | tail -n 1 | awk '{print $6}' | cut -f 2 -d=)"
        xinput disable "$touchpadid"

        ${lib.getExe pkgs.feh} --bg-center ${wallpaper}/share/wallpapers/nixos-wallpaper.png &
      '';
    };

    # re-use .xsession as .xinitrc
    home.file.".xinitrc".source = config.home.file.${config.xsession.scriptPath}.source.outPath;
  };
}
