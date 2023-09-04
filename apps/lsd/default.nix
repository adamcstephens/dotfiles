{...}: {
  xdg.configFile."lsd/colors.yaml".source = ./themes/terminal.yaml;

  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings = {
      color = {
        when = "auto";
        theme = "custom";
      };
    };
  };
}
