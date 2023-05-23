{...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      editor.color-modes = true;
    };

    languages = [
      {
        name = "nix";
        language-server = {command = "nil";};
        auto-format = true;
        formatter = {
          command = "alejandra";
          args = [];
        };
      }
    ];
  };
}
