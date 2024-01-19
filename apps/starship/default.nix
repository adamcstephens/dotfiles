{ lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      aws.disabled = true;

      battery = lib.mkIf pkgs.stdenv.isDarwin { disabled = true; };

      character = {
        format = "[─](fg:244)$symbol ";
        success_symbol = "[❯](bold yellow)";
        error_symbol = "[❯](bold red)";
      };

      container = {
        format = "[$symbol]($style) ";
      };

      gcloud.disabled = true;

      hostname = {
        style = "bold yellow";
        format = "[$hostname]($style) ";
        trim_at = "";
      };

      nix_shell = {
        format = "[($name)]($style) ";
      };

      nodejs.disabled = true;

      shell = {
        disabled = false;
        fish_indicator = "";
        format = "[$indicator]($style)";
        style = "fg:244";
      };

      username = {
        style_user = "fg:244";
        format = "[$user@]($style)";
      };
    };
  };
}
