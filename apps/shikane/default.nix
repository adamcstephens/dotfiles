{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.shikane
  ];

  systemd.user.services.shikane = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Unit.PartOf = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];

    Unit.X-Restart-Triggers = [
      config.xdg.configFile."shikane/config.toml".source
    ];

    Service = {
      ExecStart = lib.getExe pkgs.shikane;
      Restart = "on-failure";
    };
  };

  xdg.configFile."shikane/config.toml".source = (pkgs.formats.toml { }).generate "shikane" {
    profile = [
      {
        name = "desktop";
        output = [
          {
            enable = true;
            search = [
              "m=DELL P2715Q"
              "s=54KKD79CAQNL"
              "v=Dell Inc."
            ];
            mode = "3840x2160@60Hz";
            scale = 1.25;
          }
        ];
      }
      {
        name = "punk";
        output = [
          {
            enable = true;
            search = "eDP-1";
            mode = "3840x2160@60Hz";
            scale = 1.75;
          }
        ];
      }
      {
        name = "punk-docked";
        output = [
          {
            enable = false;
            search = "eDP-1";
            mode = "3840x2160@60Hz";
            scale = 1.75;
          }
          {
            enable = true;
            search = [
              "m=DELL P2715Q"
              "s=54KKD79CAQNL"
              "v=Dell Inc."
            ];
            mode = "3840x2160@60Hz";
            scale = 1.25;
          }
        ];
      }
      {
        name = "funk";
        output = [
          {
            enable = true;
            search = "eDP-1";
            mode = "2880x1920@120Hz";
            scale = 1.5;
            adaptive_sync = true;
          }
        ];
      }
      {
        name = "funk-docked";
        output = [
          {
            enable = false;
            search = "eDP-1";
            mode = "2880x1920@120Hz";
            scale = 1.5;
            adaptive_sync = true;
          }
          {
            enable = true;
            search = [
              "m=DELL P2715Q"
              "s=54KKD79CAQNL"
              "v=Dell Inc."
            ];
            mode = "3840x2160@60Hz";
            scale = 1.25;
          }
        ];
      }
    ];
  };
}
