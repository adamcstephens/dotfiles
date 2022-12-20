# thanks to https://github.com/water-sucks/nixed/blob/234512d3b5d2c9f89e1d97a6fb68ad5efb3a14d6/home/modules/programs/wob.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wob;

  generate = lib.generators.toINIWithGlobalSection {};
in {
  options.programs.wob = {
    enable = lib.mkEnableOption "Wayland overlay bar";

    # I'm lazy, so I'm just going to specify the global
    # section inside my config.
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Configuration for wob";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "programs.wob" pkgs lib.platforms.linux)
    ];

    xdg.configFile."wob/wob.ini".text = generate cfg.settings;

    systemd.user.services.wob = {
      Unit = {
        Description = "Wayland overlay bar";
        PartOf = ["wayland-session.target"];
        # ConditionPathExistsGlob = ["%t/wayland-*"];
      };

      Install.WantedBy = ["wayland-session.target"];

      Service = {
        ExecStart = "${pkgs.wob}/bin/wob";
        StandardInput = "socket";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    systemd.user.sockets.wob = {
      Socket = {
        ListenFIFO = "%t/wob.sock";
        SocketMode = 0600;
        # ConditionPathExistsGlob = ["%t/wayland-*"];
      };

      Install.WantedBy = ["sockets.target" "wayland-session.target"];
    };
  };
}
