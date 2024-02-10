{ inputs, ... }:
{
  imports = [ inputs.nix-colors.homeManagerModule ];
  # colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;
  colorScheme = {
    slug = "modus-vivendi";
    name = "Modus Vivendi";
    author = "https://git.sr.ht/~protesilaos/modus-themes";
    palette = {
      base00 = "#000000";
      base01 = "#100323";
      base02 = "#3C3C3C";
      base03 = "#595959";
      base04 = "#BEBCBF";
      base05 = "#FFFFFF";
      base06 = "#EDEAEF";
      base07 = "#FFFFFF";
      base08 = "#FF8059";
      base09 = "#EF8B50";
      base0A = "#D0BC00";
      base0B = "#44BC44";
      base0C = "#00D3D0";
      base0D = "#2FAFFF";
      base0E = "#FEACD0";
      base0F = "#B6A0FF";
    };
  };
}
