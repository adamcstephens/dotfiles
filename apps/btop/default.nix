{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      clock_format = "%H:%M - /host";
    };
  };
}
