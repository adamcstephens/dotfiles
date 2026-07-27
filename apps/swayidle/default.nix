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
      timeout 900 'app2unit -- wayland-monitor off' resume 'app2unit -- wayland-monitor on' \
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
    systemd.services.swayidle = {
      wantedBy = [ "wayland-session.target" ];
      after = [ "wayland-session.target" ];
      partOf = [ "wayland-session.target" ];

      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      serviceConfig = {
        Environment = [ "PATH=${config.directory}/bin:/run/current-system/sw/bin" ];
        ExecStart = [ (lib.getExe script) ];
        Restart = "always";
      };
    };
  };
}
