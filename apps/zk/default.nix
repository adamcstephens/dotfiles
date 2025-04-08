{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.zk;
in
{
  options.dotfiles.apps.zk = {
    enable = lib.mkEnableOption " service";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.zk ];

    xdg.configFile."zk/config.toml".source = (pkgs.formats.toml { }).generate "zk-config-toml" {
      alias = {
        recent = "zk edit --sort created- --created-after 'last two weeks' --interactive";
      };

      extra.author = "Adam C. Stephens";

      note = {
        id-charset = "alphanum";
        id-length = 6;
        id-case = "lower";
      };

      notebook.dir = "~/notebook";

      tool = {
        editor = "nvim";
        pager = "pager";
        fzf-preview = "bat -p --color always {-1}";
      };
    };
  };
}
