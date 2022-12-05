{
  config,
  pkgs,
  ...
}: let
  river =
    (pkgs.river.override {
      wlroots = pkgs.wlroots_0_16;
    })
    .overrideAttrs (_: {
      version = "0.2.0-dev";
      src = pkgs.fetchFromGitHub {
        owner = "riverwm";
        repo = "river";
        rev = "e603c5460a27bdc8ce6c32c8ee5e53fb789bc10b";
        hash = "sha256-x971VRWp72uNRNcBTU2H81EiqWa5kg0E5n7tK8ypaQM=";
        fetchSubmodules = true;
      };
    });
in {
  home.packages = [
    river
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
