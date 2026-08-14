{
  inputs,
  self,
  withSystem,
  ...
}:
let
  user = {
    directory = "/home/adam";
    user = "adam";
    clobberFiles = true;
  };

  specialArgs = {
    inherit inputs;

    flake = self;
    npins = import ../npins;
  };

  nixosCommon = [
    inputs.hjem.nixosModules.default
    {
      hjem = {
        inherit specialArgs;

        clobberByDefault = true;

        extraModules = [
          ./core.nix
        ];

        users.adam = user // {
          dotfiles.nixosManaged = true;
          files.".dotfiles".source = "${self}";
        };
      };
    }
  ];
in
{
  flake.hjemProfiles = {
    core = nixosCommon;

    dev = nixosCommon ++ [
      {
        hjem = {
          extraModules = [ ./dev.nix ];
        };
      }
    ];
  };

  flake.hjemConfigurations.deck = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.hjem.standalone.hjemConfiguration {
      inherit pkgs;

      specialArgs = specialArgs // {
        profile = "deck";
      };

      modules = [
        user
        ./core.nix
        ./dev.nix
        ./linux-gui.nix
        (
          { pkgs, ... }:
          {
            dotfiles = {
              apps = {
                # hypridle.enable = false;
                # sower.enable = true;
                # swayidle.enable = true;
                # zk.enable = true;
              };
              # gui = {
              #   dpi = 148;
              #   # autosuspend in nixos handles this
              #   dontSleep = true;
              #   wayland.enable = true;
              # };
            };

            # packages = [
            #   pkgs.sone
            # ];

            # dotfiles.apps.waybar.battery = "upower";
            # programs.waybar.settings.main.network.format-disconnected = "";
          }
        )
      ];
    }
  );
}
