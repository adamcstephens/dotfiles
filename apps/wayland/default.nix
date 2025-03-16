{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.colorScheme.palette;
  waylandLocker = pkgs.writeTextFile {
    name = "wayland-locker";
    destination = "/bin/wayland-locker";
    executable = true;
    text = # ocaml
      ''
        #!/usr/bin/env -S ocaml

        let main =
          let waylock = "waylock -fork-on-lock -init-color 0x${colors.base01} -input-color 0x${colors.base03} -fail-color 0x${colors.base08}" in
          let locker desktop = match desktop with
          | "niri" -> "gtklock"
          | _ -> waylock in
          Sys.getenv "XDG_CURRENT_DESKTOP"
          |> locker
          |> Sys.command
      '';
  };
in
{
  options.dotfiles.gui.wayland = {
    enable = lib.mkEnableOption "Enable wayland resources";
    locker = lib.mkOption {
      type = lib.types.package;
      description = "package for locking screen";
      default = waylandLocker;
    };
  };

  config = lib.mkIf config.dotfiles.gui.wayland.enable {
    home.packages = [
      pkgs.grim
      pkgs.gtklock
      pkgs.lswt
      pkgs.procps
      pkgs.qt6.qtwayland
      pkgs.slurp
      pkgs.waylock
      pkgs.wayshot
      pkgs.wdisplays
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wl-mirror
      pkgs.wlopm
      pkgs.wlr-randr
      waylandLocker
    ];
  };
}
