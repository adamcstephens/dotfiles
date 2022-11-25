{config, ...}: {
  imports = [
    ./hm-module.nix
  ];

  programs.wob = {
    enable = true;
    settings = {
      globalSection = {
        width = 256;
        height = 40;
        margin = 40;
        anchor = "bottom right";
        background_color = "${config.colorScheme.colors.base00}";
        border_color = "${config.colorScheme.colors.base03}";
        bar_color = "${config.colorScheme.colors.base09}";
      };
      sections = {};
    };
  };
}