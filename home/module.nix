{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;

  colors = config.colorScheme.palette;
  waylandLocker = pkgs.writeShellScriptBin "wayland-locker" ''
    export PATH=$PATH:${
      lib.makeBinPath [
        pkgs.gtklock
        pkgs.procps
        pkgs.waylock
      ]
    }

    if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
      gtklock
    else
      waylock -fork-on-lock -init-color 0x${colors.base01} -input-color 0x${colors.base03} -fail-color 0x${colors.base08}
    fi
  '';
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

      wayland = {
        enable = lib.mkEnableOption "Enable wayland resources";
        locker = lib.mkOption {
          type = lib.types.package;
          description = "package for locking screen";
          default = waylandLocker;
        };
      };

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
            fontDirectories =
              [
                inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.nerd-fonts.symbols-only
                pkgs.emacs-all-the-icons-fonts
                pkgs.font-awesome
                pkgs.ibm-plex
                pkgs.jetbrains-mono
              ]
              ++ lib.optionals pkgs.stdenv.isLinux [
                inputs.sandbox.packages.${pkgs.system}.apple-emoji-linux
              ]
              ++ lib.optionals pkgs.stdenv.isDarwin [ "/Library/Fonts" ];
          };
        };
      };
    };
  };
}
