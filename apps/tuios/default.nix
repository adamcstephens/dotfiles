{ config, pkgs, ... }: {
  packages = [
    pkgs.tuios
  ];

  xdg.config.files."tuios/config.toml".source = config.dotfiles.source "apps/tuios/config.toml";
}
