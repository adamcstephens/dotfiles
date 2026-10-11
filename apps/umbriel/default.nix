{ dotlib, ... }:
{
  xdg.config.files."umbriel/config.toml".source = dotlib.source "apps/umbriel/config.toml";
}
