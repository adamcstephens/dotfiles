{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.apps.ssh;
in
{
  options.apps.ssh = {
    agent = {
      askpass = lib.mkEnableOption "askpass support";
    };
    tpm = lib.mkEnableOption "ssh-tpm-agent";
  };

  config = lib.mkMerge [
    {
      packages = lib.optionals cfg.tpm [ pkgs.ssh-tpm-agent ];

      files.".ssh/config".source =
        if config.dotfiles.nixosManaged then
          ./dotfiles.config
        else
          "${config.directory}/.dotfiles/apps/ssh/dotfiles.config";
    }
    (lib.optionalAttrs (lib.hasAttr "systemd" options) {
      systemd.services = {
        ssh-agent = lib.mkIf cfg.agent.askpass {
          wantedBy = lib.mkForce [ "graphical-session.target" ];
          environment = {
            SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
          };
        };

        ssh-tpm-agent = lib.mkIf cfg.tpm {
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          requires = [ "ssh-agent.service" ];
          after = [
            "ssh-agent.service"
            "graphical-session.target"
          ];

          unitConfig = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };

          serviceConfig = {
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
