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
      ];
    }
  );
}
