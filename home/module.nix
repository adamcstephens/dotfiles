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

      insecure = lib.mkEnableOption (lib.mkDoc "Insecure GUI disables locking");

      dontSuspend = lib.mkEnableOption (lib.mdDoc "Don't automatically suspend on idle");
    };
  };
}
