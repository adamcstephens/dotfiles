{...}: {
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
