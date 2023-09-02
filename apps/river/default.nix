{config, ...}: {
  xdg.configFile."river/init" = {
    executable = true;
    source = ./init.sh;
  };

  xdg.configFile."river/colors.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh

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
