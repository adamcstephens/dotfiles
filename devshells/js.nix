{
  mkShell,
  pkgs,
}:
mkShell {
  packages = [
    pkgs.esbuild
    pkgs.nodejs
    pkgs.yarn
  ];
}
