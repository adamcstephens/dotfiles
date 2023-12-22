{...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      editor.color-modes = true;
      keys.normal."space".o = "file_picker_in_current_buffer_directory";
    };

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
            args = [];
          };
        }
      ];
    };
  };
}
