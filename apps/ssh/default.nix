{...}: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "5m";
    forwardAgent = true;

    # use header: # -*- mode: ssh-config -*-
    includes = [
      "local.config"
    ];
  };
}
