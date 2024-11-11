{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;
in
{
  options.dotfiles = {
    nixosManaged = lib.mkEnableOption "When nixos managed dotfiles is in the read-only store";

    dev.enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable dev tools";
      default = cfg.gui.enable;
    };

    gui = {
      enable = lib.mkEnableOption "gui configuration";

      drmDevices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "list of DRM device paths to use with wayland compositors";
        default = [ ];
      };

      dpi = lib.mkOption {
        type = lib.types.int;
        default = 96;
      };

      dontSleep = lib.mkEnableOption "Don't automatically sleep on idle";
      insecure = lib.mkEnableOption "Insecure GUI disables locking";
      wayland = lib.mkEnableOption "Enable wayland resources";
      xorg = {
        enable = lib.mkEnableOption "Enable xorg resources";

        wm = lib.mkOption {
          type = lib.types.enum [
            "leftwm"
            "xmonad"
          ];
          description = "which xorg window manager to enable";
          default = "xmonad";
        };
      };

      font = {
        mono = lib.mkOption {
          type = lib.types.str;
          default = "JetBrains Mono";
        };

        variable = lib.mkOption {
          type = lib.types.str;
          default = "IBM Plex Sans";
        };

        fontconfig = lib.mkOption {
          type = lib.types.unspecified;
          default = pkgs.makeFontsConf {
            fontDirectories = [
              (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
              pkgs.emacs-all-the-icons-fonts
              pkgs.font-awesome
              pkgs.ibm-plex
              pkgs.jetbrains-mono
            ] ++ lib.optionals pkgs.stdenv.isDarwin [ "/Library/Fonts" ];
          };
        };
      };
    };
  };
}
