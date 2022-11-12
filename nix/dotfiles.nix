{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles;
in {
  options.dotfiles = {
    isVM = lib.mkEnableOption "isVM";
  };
}
