{ config, ... }: {
  programs.rex = {
    enable = true;
    sshGuard = false;
  };

  services.rex = {
    enable = true;
    extraListen = [ "[::]:7297" ];
    allowAnonymous = true;
  };

  xdg.configFile = {
    "git/conf.d/50-rex.conf".source =
      "${config.programs.rex.package}/share/rex/ssh_config.d/50-rex.conf";
  };
}
