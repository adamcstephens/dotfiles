{
  config,
  lib,
  ...
}:
let
  linker = import ./smfh.nix;
  toHomeManager = lib.mapAttrs (
    _: file: {
      inherit (file) source enable force;
    }
  );
in
{
  imports = [
    (
      { pkgs, ... }:
      let
        module = linker { inherit config lib pkgs; };
      in
      module // { config = lib.mkIf (!config.dotfiles.nixosManaged) module.config; }
    )
  ];

  config = lib.mkMerge [
    (lib.mkIf config.dotfiles.nixosManaged {
      home.file = toHomeManager config.smfh.files;
      xdg.configFile = toHomeManager config.smfh.xdg.config.files;
    })
    (lib.mkIf (!config.dotfiles.nixosManaged) {
      smfh.stateFile = "${config.xdg.stateHome}/dotfiles/smfh.json";
    })
  ];
}
