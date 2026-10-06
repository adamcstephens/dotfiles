{ dotlib, ... }:
{
  environment.sessionVariables = {
    PSQLRC = "$XDG_CONFIG_HOME/postgresql/psqlrc";
  };

  xdg.config.files."postgresql/psqlrc".source = dotlib.source "apps/postgresql/psqlrc";
}
