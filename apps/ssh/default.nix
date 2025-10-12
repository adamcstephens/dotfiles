{
  config,
  lib,
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

  config = {
    home.packages = lib.optionals cfg.tpm [ pkgs.ssh-tpm-agent ];

    home.file.".ssh/config".source =
      if config.dotfiles.nixosManaged then
        ./dotfiles.config
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/ssh/dotfiles.config";

    systemd.user.services.ssh-agent = lib.mkIf cfg.agent.askpass {
      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
      Service.Environment = [
        "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
      ];
    };

    systemd.user.services.ssh-tpm-agent = lib.mkIf cfg.tpm {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [
          "ssh-agent.service"
          "graphical-session.target"
        ];
        Requires = [ "ssh-agent.service" ];
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

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
