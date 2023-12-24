{ inputs, pkgs, ... }:
let
  fd = pkgs.symlinkJoin {
    name = "fd-wrapped";
    paths = [ pkgs.fd ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/fd --add-flags "--ignore-case --hidden --follow"
    '';
  };
in
{
  home.packages = [ fd ];
}
