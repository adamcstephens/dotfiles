{
  config,
  inputs,
  lib,
  self,
  ...
}: let
  cfgs = config.profile-parts.home-manager;
in {
  imports = [
    inputs.profile-parts.flakeModules.home-manager
  ];

  profile-parts.default.home-manager = {
    inherit (inputs) home-manager nixpkgs;

    username = "adam";
    exposePackages = true;
  };

  profile-parts.global.home-manager = {
    modules = {
      name,
      profile,
    }: [
      ./core.nix
      {
        _module.args.pkgs = lib.mkForce (import profile.nixpkgs {
          inherit (profile) system;
          overlays = [self.overlays.default self.overlays.upstreams];
          config.allowUnfree = true;
        });
      }
    ];

    specialArgs = {inherit inputs;};
  };

  profile-parts.home-manager = {
    blank = {
      modules = [
        ./linux-gui.nix
        ../apps/solaar

        {dotfiles.gui.dpi = 148;}
      ];
    };

    drink = {
      modules = [
        ./linux-gui.nix
        ../apps/firefox
        ../apps/goldencheetah
        {
          dotfiles.gui.insecure = true;
          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "i965";
          };
        }
      ];
    };

    EMAT-C02G44CPQ05P = {
      username = "astephe9";
      system = "aarch64-darwin";
      modules = [./core-darwin.nix];
    };

    think = {
      modules = [
        ./linux-gui.nix
        ../apps/goldencheetah

        {dotfiles.gui.dpi = 196;}
      ];
    };

    # generic systems

    aarch64-darwin = {
      system = "aarch64-darwin";
      modules = [./core-darwin.nix];
    };

    aarch64-linux = {
      system = "aarch64-linux";
    };

    x86_64-linux = {};
  };

  flake.homeModules = builtins.mapAttrs (_: profile: profile.finalModules) cfgs;
  flake.lib.findHome = hostname: system:
    if (builtins.elem hostname (builtins.attrNames cfgs))
    then hostname
    else system;
}
