{
  config,
  dotlib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.ssh;
in
{
  options.dotfiles.apps.ssh = {
    agent.askpass.enable = lib.mkEnableOption "askpass support";
    tpm.enable = lib.mkEnableOption "ssh-tpm-agent";
  };

  config = lib.mkMerge [
    {
      home.packages = lib.optionals cfg.tpm.enable [ pkgs.ssh-tpm-agent ];

      home.file.".ssh/config".source = dotlib.source "apps/ssh/dotfiles.config";
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      systemd.user.services = {
        ssh-agent = lib.mkIf cfg.agent.askpass.enable {
          Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
          Service.Environment = [
            "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
          ];
        };

        ssh-tpm-agent = lib.mkIf cfg.tpm.enable {
          Install.WantedBy = [ "graphical-session.target" ];
          Unit.PartOf = [ "graphical-session.target" ];
          Unit.Requires = [ "ssh-agent.service" ];
          Unit.After = [
            "ssh-agent.service"
            "graphical-session.target"
          ];

          Unit = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };

          Service = {
            Type = "simple";
            Environment = [
              "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
            ];
            ExecStart = "${lib.getExe pkgs.ssh-tpm-agent} -l %t/ssh-tpm-agent -A %t/ssh-agent ";
            RestartSec = 3;
            Restart = "on-abort";
          };
        };
      };
    })
  ];
}
