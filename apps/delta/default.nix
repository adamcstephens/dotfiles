{ pkgs, ... }:
let
  package = (
    pkgs.delta.overrideAttrs (prev: {
      postInstall = prev.postInstall + ''
        mkdir -vp $out/share/delta
        cp -v themes.gitconfig $out/share/delta
      '';
    })
  );
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
