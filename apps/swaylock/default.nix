{config, ...}: {
  programs.swaylock.settings = {
    color = config.colorScheme.colors.base00;

    key-hl-color = "#bb97ee";
    bs-hl-color = config.colorScheme.colors.base09;

    inside-color = config.colorScheme.colors.base00;
    ring-color = config.colorScheme.colors.base00;

    inside-clear-color = config.colorScheme.colors.base09;
    ring-clear-color = config.colorScheme.colors.base09;

    # verification
    inside-ver-color = config.colorScheme.colors.base0E;
    ring-ver-color = config.colorScheme.colors.base0E;

    inside-wrong-color = config.colorScheme.colors.base08;
    ring-wrong-color = config.colorScheme.colors.base08;
  };
}
