{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.dotfiles.apps.walker;
in
{
  imports = [
    inputs.walker.homeManagerModules.walker
  ];

  options.dotfiles.apps.walker = {
    enable = lib.mkEnableOption "walker launcher service";
  };

  config = lib.mkIf cfg.enable {
    # home.file.".config/walker/config.toml".source =
    #   if config.dotfiles.nixosManaged then
    #     ./config.toml
    #   else
    #     config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/walker/config.toml";

    home.file.".config/walker/themes/dotfiles/style.css".text = with config.colorScheme.palette; ''
      @define-color window_bg_color #${base05};
      @define-color accent_bg_color #${base05};
      @define-color theme_fg_color #${base08};
    '';

    programs.walker = {
      enable = true;
      runAsService = true;
    };
  };
}
