{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "ssh-agent";
      Documentation = ["man:ssh-agent(1)"];
    };

    Service = {
      Environment = ["SSH_AUTH_SOCK=%t/ssh-agent.socket"];
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      Restart = "always";
    };

    Install = {
      WantedBy = config.dotfiles.gui.wantedBy;
    };
  };
}
