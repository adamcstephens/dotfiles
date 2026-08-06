{
  config,
  lib,
  ...
}:
{
  imports = [ ./colorscheme.nix ];

  colorScheme = {
    slug = "moonfly";
    name = "moonfly";
    author = "https://github.com/bluz71/vim-moonfly-colors";
    palette = {
      base00 = "#080808";
      base01 = "#100323";
      base02 = "#323437";
      base03 = "#949494";
      base04 = "#9E9E9E";
      base05 = "#EEEEEE";
      base06 = "#E4E4EF";
      base07 = "#EEEEEE";
      base08 = "#FF5D5D";
      base09 = "#FF5189";
      base0A = "#E3C78A";
      base0B = "#8CC85F";
      base0C = "#79DAC8";
      base0D = "#80A0FF";
      base0E = "#CF87E8";
      base0F = "#AE81FF";
    };
  };

  xdg.config.files."colorscheme.json".text = lib.pipe config.colorScheme [
    (lib.filterAttrs (n: _: n != "kind" && n != "colors"))
    builtins.toJSON
  ];
}
