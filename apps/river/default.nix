{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.river
  ];

  systemd.user.targets.river-session = {
    Unit = {
      Description = "river compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
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
