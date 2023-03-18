{
  stdenv,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "adamcstephens-terminfo";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;
  dontPatch = true;

  installPhase = ''
    export TERMINFO="$out/share/terminfo"
    mkdir -vp $out/share/terminfo
    ${pkgs.ncurses6}/bin/tic -x -o $out/share/terminfo xterm-screen-256color.terminfo
    ${pkgs.ncurses6}/bin/tic -x -o $out/share/terminfo xterm-emacs.terminfo
  '';
}
