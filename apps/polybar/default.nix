{config, ...}: {
  services.polybar = {
    enable = true;
    script = "polybar bar &";
    extraConfig =
      (with config.colorScheme.colors; ''
        [colors]
        background = ${base00}
        background-alt = ${base00}
        foreground = ${base05}
        primary = ${base0A}
        secondary = ${base0C}
        alert = ${base08}
        disabled = ${base03}
        border = ${base03}
      '')
      + (builtins.readFile ./config.ini);
  };
}
