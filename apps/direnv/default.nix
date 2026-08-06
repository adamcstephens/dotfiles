{ pkgs, ... }:
{
  packages = [
    pkgs.direnv
    pkgs.nix-direnv
  ];

  xdg.config.files."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
  '';
}
