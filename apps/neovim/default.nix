{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  cfg = config.dotfiles.apps.neovim;

  package = flake.packages.${pkgs.system}.neovim.override {
    inherit (cfg) full;
  };
in
{
  options.dotfiles.apps.neovim.full = lib.mkEnableOption "install the full set of tools, as if a workstation";

  config = {
    home.sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
    };

    home.packages = [ package ];
  };
}
