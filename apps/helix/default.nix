{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.helix;
in
{
  options.dotfiles.helix.enable = lib.mkEnableOption "helix app";

  config = lib.mkIf cfg.enable {
    packages = [ pkgs.helix ];

    xdg.config.files."helix/config.toml".source = ./config.toml;
    xdg.config.files."helix/languages.toml".source = ./languages.toml;
  };
}
