{...}: {
  config.dotfiles.homeConfigurations = {
    blank = {
      gui = true;
      extraModules = [
        ../apps/solaar
        {
          dotfiles.gui.dpi = 148;
        }
      ];
    };

    # drink = {
    #   gui = true;
    #   extraModules = [
    #     ../apps/firefox
    #     ../apps/goldencheetah
    #     {
    #       dotfiles.gui.insecure = true;
    #       home.sessionVariables = {
    #         LIBVA_DRIVER_NAME = "i965";
    #       };
    #
    #     }
    #   ];
    # };

    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      system = "aarch64-darwin";
    };

    think = {
      gui = true;
      extraModules = [
        ../apps/goldencheetah
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

    x86_64-linux = {};
  };
}
