{config, ...}: {
  programs.nushell = {
    enable = true;

    configFile.text = ''
      $env.config = {
        show_banner: false,
      }
    '';

    shellAliases =
      config.home.shellAliases
      // {
        esl = "exec nu -l";
        ll = "ls -l";
        l = "ls -la";
      };
  };
}
