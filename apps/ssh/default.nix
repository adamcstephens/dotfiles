{...}: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "20m";
    forwardAgent = true;

    # use header: # -*- mode: ssh-config -*-
    includes = [
      "local.config"
    ];
  };
}
