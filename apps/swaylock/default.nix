{ config, ... }:
{
  programs.swaylock.settings = {
    color = config.colorScheme.palette.base00;

    key-hl-color = "#bb97ee";
    bs-hl-color = config.colorScheme.palette.base09;

    inside-color = config.colorScheme.palette.base00;
    ring-color = config.colorScheme.palette.base00;

    inside-clear-color = config.colorScheme.palette.base09;
    ring-clear-color = config.colorScheme.palette.base09;

    # verification
    inside-ver-color = config.colorScheme.palette.base0E;
    ring-ver-color = config.colorScheme.palette.base0E;

    inside-wrong-color = config.colorScheme.palette.base08;
    ring-wrong-color = config.colorScheme.palette.base08;
  };
}
