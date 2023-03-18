# thanks to nobbz for the inspriration. https://github.com/NobbZ/nixos-config/blob/40d04634644d979aa5df5df4e32ebf1e1b79984e/parts/home_configs.nix
{
  config,
  inputs,
  lib,
  withSystem,
  ...
}: let
  cfg = config.dotfiles.homeConfigurations;
  homes = builtins.mapAttrs (_: config: config.finalHome) cfg;
  packages = builtins.attrValues (builtins.mapAttrs (_: config: config.packageModule) cfg);
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

          extraModules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            default = [];
          };

          system = lib.mkOption {
            type = lib.types.enum ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
            default = "x86_64-linux";
          };

          gui = lib.mkEnableOption "Enable linux gui support";

          # private
          finalHome = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };

          finalModules = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };

          packageName = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
          };

          finalPackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
          };

          packageModule = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
          };
        };

        config = {
          finalModules = withSystem config.system (
            {
              inputs',
              pkgs,
              ...
            }:
              [
                ../home/core.nix

                {
                  home.username = config.username;
                  home.homeDirectory =
                    if pkgs.stdenv.isDarwin
                    then "/Users/${config.username}"
                    else "/home/${config.username}";
                }
              ]
              ++ config.extraModules
              ++ (lib.optionals pkgs.stdenv.isDarwin [../home/core-darwin.nix])
              ++ (lib.optionals config.gui [../home/linux-gui.nix])
          );

          finalHome = withSystem config.system ({
            inputs',
            pkgs,
            ...
          }:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              modules = config.finalModules;

              extraSpecialArgs = {
                inherit inputs inputs';
              };
            });

          packageName = "home/config/${name}";
          finalPackage = config.finalHome.activationPackage;
          packageModule = {${config.system}.${config.packageName} = config.finalPackage;};
        };
      }));
    };
    default = {};
  };

  config.flake.homeConfigurations = homes;
  config.flake.homeModules = builtins.mapAttrs (_: value: cfg.finalModules) cfg;
  config.flake.lib.findHome = hostname: system:
    if (builtins.elem hostname (builtins.attrNames cfg))
    then hostname
    else system;
  config.flake.packages = lib.mkMerge packages;
}
