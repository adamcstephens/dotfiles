{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  epiConfig = tomlFormat.generate "epi-config.toml" {
    target =
      if pkgs.stdenv.hostPlatform.isAarch64 then "~/.dotfiles#agents-aarch64" else "~/.dotfiles#agents";
    cpus = 4;
    memory = 4096;
    mounts = [
      "~/.config/claude"
      "~/.config/opencode"
      "~/.config/pi"
      "~/.copilot"
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      "~/.config/claude-personal"
    ];
  };
in
{
  packages = [
    inputs.epi.packages.${pkgs.stdenv.hostPlatform.system}.epi
  ];

  xdg.config.files."epi/config.toml".source = epiConfig;

  xdg.config.files."epi/hooks".source =
    if config.dotfiles.nixosManaged then ./hooks else "${config.directory}/.dotfiles/apps/epi/hooks";
}
