{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gui.wayland {
    xdg.configFile."wofi/config".text = ''
      width=800
      height=400
      insensitive=true
      mode=drun,run
    '';

    xdg.configFile."wofi/style.css".text = ''
      window {
        border: 2px solid #${config.colorScheme.palette.base03};
        background-color: #${config.colorScheme.palette.base00};
      }

      #input {
        color: #${config.colorScheme.palette.base09};
        border: 2px solid #${config.colorScheme.palette.base03};
        background-color: #${config.colorScheme.palette.base00};
        font-size: 13px;
        font-family: ${config.dotfiles.gui.font.variable};
      }

      #outer-box {
        margin: 10px;
      }

      #scroll {
        margin: 5px 0px;
        font-size: 13px;
        font-family: ${config.dotfiles.gui.font.variable};
        color: #${config.colorScheme.palette.base06};
      }

      #scroll label {
        margin: 2px 0px;
      }

      #entry:selected {
        color: #${config.colorScheme.palette.base06};
        background-color: #${config.colorScheme.palette.base00};
      }
    '';

    home.packages = [ pkgs.wofi ];
  };
}
