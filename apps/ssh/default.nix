{ ... }:
{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "60m";
    serverAliveInterval = 60;
    serverAliveCountMax = 2;

    # use header: # -*- mode: ssh-config -*-
    includes = [ "local.config" ];
  };
}
