{ config, lib, pkgs, ... }:
let
  cfg = config.dotfiles.helix;
in
{
  options.dotfiles.helix.enable = lib.mkEnableOption "helix app";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.helix ];

    xdg.configFile."helix/config.toml".source = ./config.toml;
    xdg.configFile."helix/languages.toml".source = ./languages.toml;
  };
}
