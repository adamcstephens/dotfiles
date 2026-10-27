{ dotlib, ... }:
{
  home.sessionVariables = {
    PSQLRC = "$XDG_CONFIG_HOME/postgresql/psqlrc";
  };

  xdg.configFile."postgresql/psqlrc".source = dotlib.source "apps/postgresql/psqlrc";
}
