{ config, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "${config.dotfiles.gui.font.mono}:size=11";
      };
      scrollback = {
        lines = 50000;
      };
      colors = with config.colorScheme.colors; {
        background = base00;
        foreground = base05;
        regular0 = base00; # black
        regular1 = base08; # red
        regular2 = base0B; # green
        regular3 = base0A; # yellow
        regular4 = base0D; # blue
        regular5 = base0E; # magenta
        regular6 = base0C; # cyan
        regular7 = base05; # white
        bright0 = base03; # bright black
        bright1 = base09; # bright red
        bright2 = base01; # bright green
        bright3 = base02; # bright yellow
        bright4 = base04; # bright blue
        bright5 = base06; # bright magenta
        bright6 = base0F; # bright cyan
        bright7 = base07; # bright white
      };
    };
  };
}
