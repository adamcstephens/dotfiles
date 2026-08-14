{
  config,
  lib,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.shikane
  ];

  systemd.services.shikane = {
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    restartTriggers = [
      config.xdg.config.files."shikane/config.toml".source
    ];

    serviceConfig = {
      ExecStart = lib.getExe pkgs.shikane;
      Restart = "on-failure";
    };
  };

  xdg.config.files."shikane/config.toml" = {
    generator = (pkgs.formats.toml { }).generate "shikane";
    value = {
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
              search = [
                "m=0x1400"
                "s=Unknown"
                "v=California Institute of Technology"
              ];
              mode = "3840x2160@60Hz";
              scale = 1.75;
            }
          ];
        }
      ];
    };
  };
}
