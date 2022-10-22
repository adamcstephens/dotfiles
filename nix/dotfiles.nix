{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles;
in {
  options.dotfiles = {
    isNixos = lib.mkEnableOption "isNixos";
    isVM = lib.mkEnableOption "isVM";

    gui = {
      wantedBy = lib.mkOption {
        default =
          builtins.map (w: "${w}-session.target")
          (builtins.attrNames
            (lib.filterAttrs (_: e: e)
              config.dotfiles.windowManager));
      };
    };

    windowManager = {
      river = lib.mkEnableOption "river window manager";
      hyprland = lib.mkEnableOption "hyprland window manager";
    };
  };

  # config =
}
