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
          language-server = {command = "nil";};
          auto-format = true;
          formatter = {
            command = "alejandra";
            args = [];
          };
        }
        {
          name = "clojure";
          file-types = ["bb" "clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot"];
          auto-format = true;
        }
      ];
    };
  };
}
