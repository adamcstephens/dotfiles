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
          ../hjem/core.nix
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
          extraModules = [ ../hjem/dev.nix ];
        };
      }
    ];
  };

  flake.hjemConfigurations.deck = withSystem "x86_64-linux" (
    { pkgs-unstable, ... }:
    inputs.hjem.lib.hjemConfiguration {
      pkgs = pkgs-unstable;
      inherit specialArgs;

      modules = [
        user
        ../hjem/core.nix
        ../hjem/dev.nix
        ../hjem/linux-gui.nix
        (
          { pkgs, ... }:
          {
            dotfiles = {
              apps = {
                # hypridle.enable = false;
                # sower.enable = true;
                # swayidle.enable = true;
                zk.enable = true;
              };
              # gui = {
              #   dpi = 148;
              #   # autosuspend in nixos handles this
              #   dontSleep = true;
              #   wayland.enable = true;
              # };
            };

            packages = [
              pkgs.sone
            ];

            # dotfiles.apps.waybar.battery = "upower";
            # programs.waybar.settings.main.network.format-disconnected = "";
          }
        )
      ];
    }
  );
}
