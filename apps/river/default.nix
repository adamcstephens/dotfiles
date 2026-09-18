{
  config,
  lib,
  pkgs,
  ...
}:
{
  packages = [
    pkgs.river-bnf
  ];

  xdg.config.files."river/init" = {
    executable = true;
    source = config.dotfiles.source "apps/river/init.sh";
  };

  xdg.config.files."river/colors.sh" = {
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

  xdg.config.files."river/start".source =
    pkgs.writeShellApplication {
      name = "river-start";
      text = ''
        export PATH=$PATH:$HOME/.dotfiles/bin

        if ! command -v river &>/dev/null; then
          echo "!! No river binary found in path"
          exit 1
        fi

        river
      '';
    }
    |> lib.getExe;
}
