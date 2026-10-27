{
  config,
  dotlib,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.river-bnf
  ];

  xdg.configFile."river/init" = {
    source = dotlib.source "apps/river/init.sh";
  };

  xdg.configFile."river/colors.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh

      if ! command -v riverctl &>/dev/null; then
        exit 0
      fi

      # Set background and border color
      riverctl background-color 0x${config.colorScheme.palette.base00}
      riverctl border-color-focused 0x${config.colorScheme.palette.base05}
      riverctl border-color-unfocused 0x${config.colorScheme.palette.base03}
    '';
  };

  xdg.configFile."river/start".source =
    pkgs.writeShellApplication {
      name = "river-start";
      text = ''
        export XCURSOR_THEME=Bibata-Modern-Ice
        export XCURSOR_SIZE=24

        systemctl --user import-environment XCURSOR_THEME XCURSOR_SIZE

        if ! command -v river &>/dev/null; then
          echo "!! No river binary found in path"
          exit 1
        fi

        exec river
      '';
    }
    |> lib.getExe;
}
