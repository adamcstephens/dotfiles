{...}: {
  programs.starship = {
    enable = true;

    settings = {
      character = {
        format = "[─](fg:244)$symbol ";
        success_symbol = "[❯](bold yellow)";
        error_symbol = "[❯](bold red)";
      };

      gcloud = {
        disabled = true;
      };

      hostname = {
        style = "bold yellow";
        format = "[$hostname]($style) ";
        trim_at = "";
      };

      username = {
        style_user = "fg:244";
        format = "[$user@]($style)";
      };
    };
  };
}
