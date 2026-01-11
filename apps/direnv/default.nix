{ pkgs, ... }:
{
  home.packages = [
    pkgs.direnv
    pkgs.nix-direnv
  ];

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';
}
