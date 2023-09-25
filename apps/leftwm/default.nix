{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../xorg
  ];

  config = lib.mkIf (config.dotfiles.gui.xorg.enable && config.dotfiles.gui.xorg.wm == "leftwm") {
    home.packages = [
      pkgs.leftwm
    ];

    xdg.configFile."leftwm/config.ron".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/leftwm/config.ron";

    xdg.configFile."leftwm/themes/current/theme.ron".text = with config.colorScheme.colors; ''
      (border_width: 1,
      margin: 0,
      background_color: "#${base00}",
      default_border_color: "#${base02}",
      floating_border_color: "#${base09}",
      focused_border_color: "#${base06}",
      )
    '';

    xdg.configFile."leftwm/themes/current/up" = {
      executable = true;
      text = ''
        #!${lib.getExe pkgs.bash}
        ${pkgs.leftwm}/bin/leftwm-command "LoadTheme ~/.config/leftwm/themes/current/theme.ron"
      '';
    };

    xdg.configFile."leftwm/themes/current/down" = {
      executable = true;
      text = ''
        #!${lib.getExe pkgs.bash}
        ${pkgs.leftwm}/bin/leftwm-command "UnloadTheme"
      '';
    };

    xsession.windowManager.command = "${pkgs.systemd}/bin/systemd-cat --identifier=leftwm ${lib.getExe pkgs.leftwm}";
  };
}
