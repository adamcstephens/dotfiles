{
  config,
  flake,
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

    profile = lib.mkOption {
      type = lib.types.str;
      description = "name of home profile from flake";
      default = pkgs.stdenv.hostPlatform.system;
    };

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
      sleepTimeout = lib.mkOption {
        type = lib.types.int;
        description = "when to sleep";
        default = 360;
      };

      insecure = lib.mkEnableOption "Insecure GUI disables locking";

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
              pkgs.nerd-fonts.symbols-only
              pkgs.font-awesome
              pkgs.ibm-plex
              pkgs.jetbrains-mono
              pkgs.noto-fonts
            ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ "/Library/Fonts" ];
          };
        };
      };
    };
  };
}
