{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.zk;

  zk = pkgs.symlinkJoin {
    name = "zk-wrapped";
    paths = [ pkgs.zk ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zk \
        --set ZK_NOTEBOOK_DIR "${cfg.defaultNotebook}"
    '';
  };
in
{
  options.dotfiles.apps.zk = {
    enable = lib.mkEnableOption " service";

    defaultNotebook = lib.mkOption {
      type = lib.types.str;
      description = "where to store the default notebook";
      default = "${config.directory}/notebook";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ zk ];

    xdg.config.files."zk/config.toml".source = (pkgs.formats.toml { }).generate "zk-config-toml" {
      alias = {
        recent = "zk edit --sort created- --created-after 'last two weeks' --interactive";
        push = ''git add . && git commit -m "checkpoint-$(date -u +'%Y-%m-%dT%H:%M:%SZ')" && git push'';
      };

      extra.author = "Adam C. Stephens";

      note = {
        id-charset = "alphanum";
        id-length = 6;
        id-case = "lower";
      };

      notebook.dir = cfg.defaultNotebook;

      tool = {
        editor = "nvim";
        pager = "pager";
        fzf-preview = "bat -p --color always {-1}";
      };
    };
  };
}
