{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xob;

  generate = lib.generators.toPretty { };
  stylesCfg = builtins.toString (
    builtins.map
      (name: ''
        ${name} = ${generate cfg.styles.${name}};
      '')
      (builtins.attrNames cfg.styles)
  );

  script = pkgs.writeScript "xob-script" ''
    #!${lib.getExe pkgs.bash}

    ${pkgs.coreutils}/bin/tail -F $XDG_RUNTIME_DIR/xob.sock | ${pkgs.xob}/bin/xob
  '';
in
{
  options.services.xob = {
    enable = lib.mkEnableOption "X overlay bar";

    styles = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Styles configuration for xob";
    };

    systemdTarget = lib.mkOption {
      type = lib.types.str;
      default = "graphical-session.target";
      example = "xserver-session.target";
      description = ''
        The systemd target that will automatically start the service.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [ (lib.hm.assertions.assertPlatform "services.xob" pkgs lib.platforms.linux) ];

    xdg.configFile."xob/styles.cfg".text = stylesCfg;

    systemd.user.services.xob = {
      Unit = {
        Description = "X overlay bar";
        PartOf = [ cfg.systemdTarget ];
      };

      Install.WantedBy = [ cfg.systemdTarget ];

      Service = {
        ExecStart = script.outPath;
        StandardInput = "socket";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    systemd.user.sockets.xob = {
      Socket = {
        ListenFIFO = "%t/xob.sock";
        SocketMode = 600;
      };

      Install.WantedBy = [ cfg.systemdTarget ];
    };
  };
}
