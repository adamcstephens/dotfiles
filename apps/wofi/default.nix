{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."wofi/config".text = ''
    width=800
    height=400
    insensitive=true
    mode=drun,run
  '';

  xdg.configFile."wofi/style.css".text = ''
    window {
      border: 2px solid #${config.colorScheme.colors.base03};
      background-color: #${config.colorScheme.colors.base00};
    }

    #input {
      color: #${config.colorScheme.colors.base09};
      border: 2px solid #${config.colorScheme.colors.base03};
      background-color: #${config.colorScheme.colors.base00};
      font-size: 18px;
    }

    #outer-box {
      margin: 10px;
    }

    #scroll {
      margin: 5px 0px;
      font-size: 16px;
      color: #${config.colorScheme.colors.base0B};
    }

    #scroll label {
      margin: 2px 0px;
    }

    #entry:selected {
      color: #${config.colorScheme.colors.base0B};
      background-color: #${config.colorScheme.colors.base00};
    }
  '';

  home.packages = [
    pkgs.wofi
  ];
}
