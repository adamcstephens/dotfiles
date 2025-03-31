{
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.apps.emacs;
in
{
  options = {
    dotfiles.apps.emacs = {
      enable = lib.mkEnableOption "emacs";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = ./doom.d;
      doomLocalDir = "${config.home.homeDirectory}/.dotfiles/apps/emacs/doom.d";
    };
  };
}
