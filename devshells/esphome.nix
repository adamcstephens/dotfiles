{
  pkgs,
  mkShellNoCC,
}:
mkShellNoCC {
  name = "esphome";
  packages = [
    pkgs.esphome
    pkgs.esptool
  ];
}
