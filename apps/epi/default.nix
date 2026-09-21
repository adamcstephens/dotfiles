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
    memory = 8192;
    mounts = [
      "~/.config/claude"
      "~/.config/codex"
      "~/.config/omp/agent/sessions"
      "~/.config/opencode"
      "~/.config/pi"
      "~/.config/veans"
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

  xdg.config.files."epi/hooks".source = config.dotfiles.source "apps/epi/hooks";
}
