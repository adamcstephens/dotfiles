{...}: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    forwardAgent = true;

    # use header: # -*- mode: ssh-config -*-
    includes = [
      "local.config"
    ];
  };
}
