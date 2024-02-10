{ config, ... }:
{
  imports = [ ./hm-module.nix ];

  services.xob = {
    enable = true;
    styles = {
      default = {
        x = {
          relative = 1;
          offset = -48;
        };
        y = {
          relative = 0.5;
          offset = 0;
        };
        length = {
          relative = 0.3;
          offset = 0;
        };
        thickness = 24;
        outline = 3;
        border = 4;
        padding = 3;
        orientation = "vertical";

        overflow = "proportional";

        color = {
          normal = {
            fg = "#ffffff";
            bg = "#00000090";
            border = "#ffffff";
          };
          alt = {
            fg = "#555555";
            bg = "#00000090";
            border = "#555555";
          };
          overflow = {
            fg = "#ff0000";
            bg = "#00000090";
            border = "#ff0000";
          };
          altoverflow = {
            fg = "#550000";
            bg = "#00000090";
            border = "#550000";
          };
        };
      };
    };
    # settings = {
    #   globalSection = {
    #     width = 256;
    #     height = 40;
    #     margin = 40;
    #     anchor = "bottom right";
    #     background_color = "${config.colorScheme.palette.base00}";
    #     border_color = "${config.colorScheme.palette.base03}";
    #     bar_color = "${config.colorScheme.palette.base09}";
    #   };
    #   sections = {};
    # };
    systemdTarget = "xserver-session.target";
  };
}
