{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.apps.swayidle;

  script = pkgs.writeShellApplication {
    name = "swayidle-start";
    text = ''
      ${lib.getExe pkgs.swayidle} \
      idlehint 120 \
      timeout 600 'app2unit -- wayland-locker' \
      timeout 900 'app2unit -- wayland-monitor off' \
    ''
    + lib.optionalString (!config.dotfiles.gui.dontSleep) "timeout 360 'systemctl sleep' \\"
    + ''
      after-resume 'app2unit -- wayland-monitor on' \
      before-sleep 'app2unit -- wayland-locker'
    '';
  };
in
{
  options.dotfiles.apps.swayidle.enable = lib.mkEnableOption "swayidle";

  config = lib.mkIf cfg.enable {
    systemd.user.services.swayidle = {
      Install = {
        WantedBy = [ "wayland-session.target" ];
      };

      Service = {
        Environment = [ "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin" ];
        ExecStart = [ (lib.getExe script) ];
        Restart = "always";
      };

      Unit = {
        After = [ "wayland-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        PartOf = [ "wayland-session.target" ];
      };
    };
  };
}
