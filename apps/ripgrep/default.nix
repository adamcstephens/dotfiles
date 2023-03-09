{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ripgrep
  ];
  home.sessionVariables.RIPGREP_CONFIG_PATH = ./ripgreprc;
}
