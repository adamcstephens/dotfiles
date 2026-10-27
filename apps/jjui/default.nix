{
  dotlib,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jjui
  ];

  xdg.configFile."jjui/config.toml".source = dotlib.source "apps/jjui/config.toml";
}
