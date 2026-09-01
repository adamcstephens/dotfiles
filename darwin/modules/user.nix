{
  flake,
  inputs,
  npins,
  lib,
  pkgs,
  ...
}:
{
  hjem = {
    clobberByDefault = true;

    specialArgs = {
      inherit flake inputs npins;
    };

    extraModules = [
      ../../hjem/darwin.nix
    ];

    users.adam = {
      directory = "/Users/adam";
      user = "adam";
      packages = [
        pkgs.e1s
        pkgs.terraform-mcp-server
        pkgs.typescript-language-server
      ];
    };
  };

  launchd.user.agents.atuin.serviceConfig = {
    KeepAlive = true;
    Program =
      pkgs.writeShellApplication {
        name = "atuin-daemon";

        runtimeInputs = [
          pkgs.atuin
        ];

        text = ''
          # force clean atuin socket in case of crash https://github.com/atuinsh/atuin/issues/2289
          rm -f /Users/adam/.local/share/atuin/atuin.sock

          exec atuin daemon
        '';
      }
      |> lib.getExe;
    RunAtLoad = true;
  };

  system.primaryUser = "adam";

  users.users.adam = {
    home = "/Users/adam";
    shell = "/home/adam/.nix-profile/bin/fish";
  };
}
