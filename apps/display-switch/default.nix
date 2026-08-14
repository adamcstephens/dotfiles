# example:
# display-switch = {
#   enable = true;
#   settings = {
#     globalSection = {
#       usb_device = "047d:8018";
#       on_usb_connect = "DisplayPort1";
#       on_usb_disconnect = "DisplayPort2";
#     };
#   };
# };
{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  cfg = config.dotfiles.apps.display-switch;

  configDir =
    if pkgs.stdenv.hostPlatform.isLinux then ".config/display-switch" else "Library/Preferences";
  format = pkgs.formats.iniWithGlobalSection { };
  configFile = format.generate "display-switch.ini" cfg.settings;
in
{
  options.dotfiles.apps.display-switch = {
    enable = lib.mkEnableOption "usb triggered display switch service";
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [
      flake.packages.${pkgs.stdenv.hostPlatform.system}.display-switch
    ];

    files."${configDir}/display-switch.ini".source = configFile;
  };
}
