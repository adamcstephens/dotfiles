{
  config,
  flake,
  inputs,
  npins,
  pkgs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit flake inputs npins;
    };

    users.adam = {
      imports = [
        ../../home/darwin.nix
        ../../apps/rex
        {
          dotfiles.apps.paseo.profiles = {
            claude = true;
            omp = false;
          };
        }
      ];

      home = {
        username = "adam";
        homeDirectory = "/Users/adam";
        packages = [
          pkgs.e1s
          pkgs.terraform-mcp-server
          pkgs.typescript-language-server
        ];
      };
    };
  };

  system.primaryUser = "adam";

  users.users.adam = {
    home = "/Users/adam";
    shell = "${config.home-manager.users.adam.home.profileDirectory}/bin/fish";
  };
}
