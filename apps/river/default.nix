{
  config,
  inputs',
  pkgs,
  ...
}: let
  rev = "refs/tags/v0.2.0";
  hash = "sha256-BrOZch6wkiBB4rk0M7Aoy8sZh8uOTQFOPxd3xLyy/K0=";

  devVer = builtins.substring 0 8 rev;
  river = pkgs.river.overrideAttrs (_: {
    version = "0.2.0";
    src = pkgs.fetchFromGitHub {
      inherit rev hash;

      owner = "riverwm";
      repo = "river";
      fetchSubmodules = true;
    };
  });
in {
  home.packages = [
    pkgs.river
  ];

  xdg.configFile."river/init" = {
    executable = true;
    source = ./river.sh;
  };

  xdg.configFile."river/colors.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh

      export XDG_DATA_DIRS="${config.home.pointerCursor.package}:$XDG_DATA_DIRS"
      export XCURSOR_THEME="${config.home.pointerCursor.name}"

      # Set background and border color
      riverctl background-color 0x${config.colorScheme.colors.base00}
      riverctl border-color-focused 0x${config.colorScheme.colors.base05}
      riverctl border-color-unfocused 0x${config.colorScheme.colors.base03}
    '';

    onChange = ''
      ~/.config/river/colors.sh
    '';
  };
}
