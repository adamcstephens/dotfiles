{...}: {
  programs.starship = {
    enable = true;

    settings = {
      aws.disabled = true;

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
        format = "[\($name\)]($style) ";
      };

      nodejs.disabled = true;

      username = {
        style_user = "fg:244";
        format = "[$user@]($style)";
      };
    };
  };
}
