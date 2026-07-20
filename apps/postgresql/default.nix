{ config, ... }:
{
  environment.sessionVariables = {
    PSQLRC = "$XDG_CONFIG_HOME/postgresql/psqlrc";
  };

  xdg.config.files."postgresql/psqlrc".source =
    if config.dotfiles.nixosManaged then
      ./psqlrc
    else
      "${config.directory}/.dotfiles/apps/postgresql/psqlrc";
}
