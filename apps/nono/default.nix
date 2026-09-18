{
  config,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.nono
  ];

  xdg.config.files."nono/profiles".source = config.dotfiles.source "apps/nono/profiles";
}
