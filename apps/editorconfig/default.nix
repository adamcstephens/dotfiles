{ ... }:
{
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        end_of_line = "lf";
        indent_style = "space";
        indent_size = 2;
      };

      "*.fish" = {
        indent_size = 4;
      };

      "*.{nim,nims}" = {
        indent_size = 2;
      };

      "*.nu" = {
        indent_size = 2;
      };

      "*.org" = {
        indent_size = 8;
      };

      "*.py" = {
        indent_size = 4;
      };

      "*.rs" = {
        indent_size = 4;
      };

      "justfile" = {
        indent_size = 4;
      };

      "Makefile" = {
        indent_style = "tab";
      };
    };
  };
}
