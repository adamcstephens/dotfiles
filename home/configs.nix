{...}: {
  config.dotfiles.homeConfigurations = {
    blank = {
      gui = true;
      extraModules = [
        ../apps/goldencheetah
        ../apps/nix/nixpkgs-dev.nix
        {
          dotfiles.gui.dpi = 148;
        }
      ];
    };

    bonk = {
      gui = true;
      extraModules = [
        {
          dotfiles.gui.dpi = 148;
        }
      ];
    };

    drink = {
      gui = true;
      extraModules = [
        ../apps/goldencheetah
        {
          dotfiles.gui.insecure = true;
          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "i965";
          };
          programs.firefox.enable = true;
          programs.firefox.profiles = {
            default = {
              id = 0;
              settings = {
                "media.ffmpeg.vaapi.enabled" = true;
                "media.ffvpx.enabled" = false;
                "media.av1.enabled" = false;
                "gfx.webrender.all" = true;
              };
            };
          };
        }
      ];
    };

    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      system = "aarch64-darwin";
    };

    silver = {
      gui = true;
      system = "aarch64-linux";
    };

    think = {
      gui = true;
      extraModules = [
        ../apps/goldencheetah
        ../apps/kmonad
        {
          dotfiles.gui.dpi = 196;
        }
      ];
    };

    # generic systems

    aarch64-darwin = {
      system = "aarch64-darwin";
    };

    aarch64-linux = {
      system = "aarch64-linux";
    };

    armv6l-linux = {
      system = "armv6l-linux";
    };

    x86_64-linux = {};
  };
}
