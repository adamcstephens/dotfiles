{
  config,
  inputs,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.walker;
  walker = pkgs.callPackage "${npins.walker}/nix/package.nix" { };
in
{
  imports = [
    inputs.elephant.homeManagerModules.elephant
  ];

  options.dotfiles.apps.walker = {
    enable = lib.mkEnableOption "walker launcher service";
  };

  config = lib.mkIf cfg.enable {
    programs.elephant.enable = true;

    home.packages = [
      walker
    ];

    home.file.".config/elephant/websearch.toml".source =
      if config.dotfiles.nixosManaged then
        ./elephant/websearch.toml
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/walker/elephant/websearch.toml";

    home.file.".config/walker/config.toml".source =
      if config.dotfiles.nixosManaged then
        ./config.toml
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/walker/config.toml";

    home.file.".config/walker/themes/dotfiles/style.css".text = with config.colorScheme.palette; ''
      @define-color window_bg_color #${base05};
      @define-color accent_bg_color #${base05};
      @define-color theme_fg_color #${base08};
    '';

    systemd.user.services.walker = {
      Unit = {
        Description = "Walker - Application Runner";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        After = [
          "graphical-session.target"
          "elephant.service"
        ];
        Requires = [ "elephant.service" ];
        PartOf = [ "graphical-session.target" ];
        X-Restart-Triggers = [
          (builtins.hashString "sha256" (
            builtins.toJSON {
              config = config.home.file.".config/walker/config.toml".source;
              theme = config.home.file.".config/walker/themes/dotfiles/style.css".source;
            }
          ))
        ];
      };
      Service = {
        ExecStart = "${lib.getExe walker} --gapplication-service";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
