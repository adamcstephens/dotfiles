{...}: {
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        end_of_line = "lf";
        insert_final_newline = true;
        indent_style = "space";
        indent_size = 2;
      };

      "[*.fish]" = {
        indent_size = 4;
      };
      "[*.{js,py}]" = {
        charset = "utf-8";
      };

      "[*.py]" = {
        indent_size = 4;
      };

      # Tab indentation (no size specified)
      "[Makefile]" = {
        indent_style = "tab";
      };

      "[justfile]" = {
        indent_size = 4;
      };

      "[*.{nim,nims}]" = {
        indent_size = 4;
      };
    };
  };
}
