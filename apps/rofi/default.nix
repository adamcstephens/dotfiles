{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    terminal = "${config.programs.kitty.package}/bin/kitty";
    package = with pkgs; rofi.override {plugins = [rofi-calc rofi-emoji];};
    # font = with config.theme.fonts; "${gui.package} 14";
    theme = let
      mkLiteral = config.lib.formats.rasi.mkLiteral;
    in
      with config.colorScheme.colors; {
        "*" = {
          bg0 = mkLiteral "#${base00}";
          bg1 = mkLiteral "#${base05}";
          fg0 = mkLiteral "#${base05}";
          fg1 = mkLiteral "#${base06}";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "element-icon, element-text, scrollbar" = {
          cursor = mkLiteral "pointer";
        };

        "window" = {
          background-color = mkLiteral "@bg0";
          border = mkLiteral "1px";
          border-color = mkLiteral "@bg1";
          border-radius = mkLiteral "6px";
        };

        "inputbar" = {
          spacing = mkLiteral "8px";
          padding = mkLiteral "4px 8px";
          children = mkLiteral "[ icon-search, entry ]";

          background-color = mkLiteral "@bg0";
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        "icon-search" = {
          expand = false;
          filename = mkLiteral "[ search-symbolic ]";
          size = mkLiteral "14px";
        };

        "textbox" = {
          padding = mkLiteral "4px 8px";
          background-color = mkLiteral "@bg0";
        };

        "listview" = {
          padding = mkLiteral "4px 0px";
          lines = 12;
          columns = 1;
        };

        "element" = {
          padding = mkLiteral "4px 8px";
          spacing = mkLiteral "8px";
        };

        "element normal urgent" = {
          text-color = mkLiteral "@fg1";
        };

        "element normal active" = {
          text-color = mkLiteral "@fg1";
        };

        "element selected" = {
          text-color = mkLiteral "@bg0"; #1
          background-color = mkLiteral "@fg1";
        };

        "element selected urgent" = {
          background-color = mkLiteral "@fg1";
        };

        "element-icon" = {
          size = mkLiteral "0.8em";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };

        "scrollbar" = {
          handle-width = mkLiteral "4px";
          handle-color = mkLiteral "@fg1";
          padding = mkLiteral "0 4px";
        };
      };

    extraConfig = {
      show-icons = true;
      modi = "drun,emoji";
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
      kb-accept-entry = "Control+m,Return,KP_Enter";
      kb-remove-to-eol = "Control+Shift+e";
      kb-mode-next = "Shift+Right,Control+Tab";
      kb-mode-previous = "Shift+Left,Control+Shift+Tab";
      kb-remove-char-back = "BackSpace";
    };
  };
}
