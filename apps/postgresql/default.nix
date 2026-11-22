{ dotlib, ... }:
{
  home.sessionVariables = {
    PSQLRC = "$XDG_CONFIG_HOME/postgresql/psqlrc";
  };

  smfh.xdg.config.files."postgresql/psqlrc".source = dotlib.source "apps/postgresql/psqlrc";
}
