{...}: {
  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings = {
      color = {
        when = "auto";
        theme = ./themes/terminal.yaml;
      };
    };
  };
}
