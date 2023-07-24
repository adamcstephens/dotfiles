# thanks to nobbz for the inspriration. https://github.com/NobbZ/nixos-config/blob/40d04634644d979aa5df5df4e32ebf1e1b79984e/parts/home_configs.nix
{
  config,
  inputs,
  lib,
  self,
  withSystem,
  ...
}: let
  cfgs = config.dotfiles.homeConfigurations;

  homes = lib.mapAttrs (name: part: part.finalProfile) cfgs;
in {
  options = {
    dotfiles.homeConfigurations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            default = "adam";
          };

          system = lib.mkOption {
            type = lib.types.enum ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "armv6l-linux"];
            default = "x86_64-linux";
          };

          extraModules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            default = [];
          };

          gui = lib.mkEnableOption "Enable linux gui support";

          finalProfile = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };

          finalModules = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };
        };

        config = {
          finalModules = withSystem config.system (
            {pkgs, ...}:
              [
                ../home/core.nix
                {
                  _module.args.pkgs = lib.mkForce (import self.inputs.nixpkgs {
                    inherit (config) system;
                    overlays = [self.overlays.default self.overlays.upstreams];
                    config.allowUnfree = true;
                  });
                }
              ]
              ++ config.extraModules
              ++ (lib.optionals pkgs.stdenv.isDarwin [../home/core-darwin.nix])
              ++ (lib.optionals config.gui [../home/linux-gui.nix])
          );

          finalProfile = {
            inherit (config) system username;

            modules = config.finalModules;

            specialArgs = {inherit inputs;};
          };
        };
      }));
    };
    default = {};
  };

  config = {
    profile-parts.home-manager = homes;
    flake.homeModules = builtins.mapAttrs (_: value: value.finalModules) cfgs;
    flake.lib.findHome = hostname: system:
      if (builtins.elem hostname (builtins.attrNames cfgs))
      then hostname
      else system;
  };
}
