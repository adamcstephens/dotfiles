{ config, ... }:
{
  environment.sessionVariables = {
    PSQLRC = "$XDG_CONFIG_HOME/postgresql/psqlrc";
  };

  xdg.config.files."postgresql/psqlrc".source = config.dotfiles.source "apps/postgresql/psqlrc";
}
