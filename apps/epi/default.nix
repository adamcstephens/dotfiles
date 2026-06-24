{
  config,
  inputs,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  epiConfig = tomlFormat.generate "epi-config.toml" {
    target = if pkgs.stdenv.isAarch64 then "~/.dotfiles#agents-aarch64" else "~/.dotfiles#agents";
    cpus = 4;
    memory = 4096;
    mounts = [
      "~/.config/claude"
      "~/.config/opencode"
      "~/.config/pi"
      "~/.copilot"
    ];
  };
in
{
  home.packages = [
    inputs.epi.packages.${pkgs.stdenv.hostPlatform.system}.epi
  ];

  xdg.configFile."epi/config.toml".source = epiConfig;

  xdg.configFile."epi/hooks".source =
    if config.dotfiles.nixosManaged then
      ./hooks
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/epi/hooks";
}
