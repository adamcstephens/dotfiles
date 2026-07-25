{
  inputs,
  self,
  ...
}:
let
  common = [
    inputs.hjem.nixosModules.default
    {
      hjem = {
        clobberByDefault = true;

        specialArgs = {
          inherit inputs;

          flake = self;
          npins = import ../npins;
        };
        extraModules = [
          ../hjem/core.nix
        ];

        users.adam = {
          directory = "/home/adam";
          user = "adam";

          dotfiles.nixosManaged = true;

          files.".dotfiles".source = "${self}";
        };
      };
    }
  ];
in
{
  flake.hjemProfiles = {
    core = common;

    dev = common ++ [
      {
        hjem = {
          extraModules = [ ../hjem/dev.nix ];
        };
      }
    ];
  };
}
