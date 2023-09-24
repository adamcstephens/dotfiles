{
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.dotfiles = {
    nixosManaged = lib.mkEnableOption "When nixos managed dotfiles is in the read-only store";

    gui = {
      dpi = lib.mkOption {
        type = lib.types.int;
        default = 96;
      };

      dontSuspend = lib.mkEnableOption (lib.mdDoc "Don't automatically suspend on idle");
      insecure = lib.mkEnableOption (lib.mkDoc "Insecure GUI disables locking");
      wayland = lib.mkEnableOption (lib.mdDoc "Enable wayland resources");
      xorg = {
        enable = lib.mkEnableOption (lib.mdDoc "Enable xorg resources");

        wm = lib.mkOption {
          type = lib.types.enum ["leftwm" "xmonad"];
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
          default = "SF Pro Text";
        };

        fontconfig = lib.mkOption {
          type = lib.types.unspecified;
          default = pkgs.makeFontsConf {
            fontDirectories =
              [
                (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
                inputs.apple-fonts.packages.${pkgs.system}.sf-pro
                pkgs.emacs-all-the-icons-fonts
                pkgs.font-awesome
                pkgs.jetbrains-mono
                pkgs.noto-fonts
                pkgs.noto-fonts-cjk
                pkgs.noto-fonts-emoji
              ]
              ++ (lib.optionals pkgs.stdenv.isDarwin [
                "/Library/Fonts"
              ]);
          };
        };
      };
    };
  };
}
