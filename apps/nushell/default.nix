{config, ...}: {
  programs.nushell = {
    enable = true;

    configFile.source = ./config.nu;

    shellAliases =
      config.home.shellAliases
      // {
        esl = "exec nu -l";
        ll = "ls -l";
        l = "ls -la";
      };
  };
}
