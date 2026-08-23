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

  standaloneModules = [
    user
    ./core.nix
    ./dev.nix
    ./linux-gui.nix
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

  flake.hjemConfigurations = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      deck = inputs.hjem.standalone.hjemConfiguration {
        inherit pkgs;

        specialArgs = specialArgs // {
          profile = "deck";
        };

        modules = standaloneModules;
      };

      punk = inputs.hjem.standalone.hjemConfiguration {
        inherit pkgs;

        specialArgs = specialArgs // {
          profile = "punk";
        };

        modules = standaloneModules ++ [
          {
            dotfiles.apps.ssh.tpm.enable = true;
          }
        ];
      };
    }
  );

  flake.packages.x86_64-linux = {
    "hjem/deck" = self.hjemConfigurations.deck.toplevel;
    "hjem/punk" = self.hjemConfigurations.punk.toplevel;
  };
}
