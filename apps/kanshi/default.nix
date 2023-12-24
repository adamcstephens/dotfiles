# right offests
#   1.00, 3840 x 2160
#   1.25, 3072 x 864
#   1.28, 3000 x 843.75
#   1.32, 2909.091 x 818.1819
#   1.35, 2844.4443 x 800
#   1.40, 2742.8571 x 1542.8571
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gui.wayland {
    services.kanshi = {
      enable = true;
      systemdTarget = "wayland-session.target";
      profiles = {
        docked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "Dell Inc. DELL P2715Q 54KKD79CAQNL";
              scale = 1.4;
            }
          ];
        };
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 2.0;
              status = "enable";
            }
          ];
        };
        desktop = {
          outputs = [
            {
              criteria = "Dell Inc. DELL P2715Q 54KKD79CAQNL";
              scale = 1.45;
            }
          ];
        };
        desktop-plus-crashcart = {
          outputs = [
            {
              criteria = "Dell Inc. DELL P2715Q 54KKD79CAQNL";
              scale = 1.45;
            }
            {
              criteria = "DP-1";
              status = "disable";
            }
          ];
        };
      };
    };

    systemd.user.services.kanshi = {
      Service = {
        Environment = [
          "PATH=${pkgs.river}/bin:${pkgs.bash}/bin:${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:$PATH"
        ];
        RestartSec = "5s";
      };
    };
  };
}
