{
  config,
  inputs',
  pkgs,
  ...
}: let
  rev = "095749b9898cd92fa7dcaa9851457b73bdb56241";
  hash = "sha256-QrJcKkf2093awTMgpkWCvqV4EWl/5I/GJzGa8eIYLaE=";

  devVer = builtins.substring 0 8 rev;
  package = pkgs.river.overrideAttrs (_: {
    version = "0.3.0-${devVer}";
    src = pkgs.fetchFromGitHub {
      inherit rev hash;

      owner = "riverwm";
      repo = "river";
      fetchSubmodules = true;
    };
  });
in {
  home.packages = [
    # package
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
