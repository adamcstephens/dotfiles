{
  mkShell,
  pkgs,
}:
mkShell {
  name = "media";

  packages = [
    pkgs.beets
    pkgs.mediainfo
  ];
}
