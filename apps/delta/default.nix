{ pkgs, ... }:
let
  package = pkgs.symlinkJoin {
    name = "delta-wrapped";
    paths = [ pkgs.delta ];
    postBuild = ''
      mkdir -vp $out/share/delta
      cp -v ${pkgs.delta.src}/themes.gitconfig $out/share/delta
    '';
    meta.mainProgram = "et";
  };
in
{
  home.packages = [
    package
  ];

  home.file.".config/git/config.delta".text = ''
    [include]
    path = ${package}/share/delta/themes.gitconfig
  '';
}
