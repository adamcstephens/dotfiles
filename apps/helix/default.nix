{ config, lib, ... }:
let
  cfg = config.dotfiles.helix;
in
{
  options.dotfiles.helix.enable = lib.mkEnableOption "helix app";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor.color-modes = true;
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "nixfmt";
              args = [ ];
            };
          }
        ];
      };
    };
  };
}
