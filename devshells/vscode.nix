{
  devShells,
  mkShell,
  pkgs,
}:
mkShell {
  packages = [ pkgs.vsce ] ++ devShells.js.nativeBuildInputs;
}
