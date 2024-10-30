{ config, ... }:
{
  home.sessionVariables = {
    PSQLRC = "$XDG_CONFIG_HOME/postgresql/psqlrc";
  };

  xdg.configFile."postgresql/psqlrc".source =
    if config.dotfiles.nixosManaged then
      ./psqlrc
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/postgresql/psqlrc";
}
