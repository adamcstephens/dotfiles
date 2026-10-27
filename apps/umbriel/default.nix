{ dotlib, ... }:
{
  xdg.configFile."umbriel/config.toml".source = dotlib.source "apps/umbriel/config.toml";
}
