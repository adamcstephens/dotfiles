{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  config-script = pkgs.runCommandNoCC "dunst-config-setup" { buildInputs = [ pkgs.nushell ]; } ''
    mkdir -p $out/bin
    cp ${./dunst-config-setup} $out/bin/dunst-config-setup
    patchShebangs $out/bin
  '';
in
{
  services.dunst = {
    enable = true;

    configFile = "${config.xdg.configHome}/dunst/final.dunstrc";

    iconTheme = {
      inherit (config.gtk.iconTheme) name package;
    };

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        font = "${config.dotfiles.gui.font.variable} 11";
        width = 300;
        height = 100;
        origin = "top-right";
        offset = "20x50";
        frame_color = "#${config.colorScheme.palette.base05}";
        frame_width = 1;
        separator_color = "frame";
      };
    };
  };

  systemd.user.services.dunst = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service.ExecStartPre = lib.getExe config-script;
    Service.Environment = lib.mkForce [ "FONTCONFIG_FILE=${config.dotfiles.gui.font.fontconfig}" ];
  };

  xdg.configFile."dunst/theme-dark.conf".source =
    npins."modus-themes.nvim" + "/extras/dunst/modus_vivendi.dunstrc";
  xdg.configFile."dunst/theme-light.conf".source =
    npins."modus-themes.nvim" + "/extras/dunst/modus_operandi.dunstrc";
}
