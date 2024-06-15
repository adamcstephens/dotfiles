{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.atuin = {
    enable = true;
    package =
      if (lib.versionAtLeast pkgs.atuin.version "18.3.0") then
        pkgs.atuin
      else
        pkgs.atuin.overrideAttrs (old: {
          patches = [
            # https://github.com/Mic92/dotfiles/blob/main/home-manager/pkgs/atuin/0001-make-atuin-on-zfs-fast-again.patch
            (pkgs.fetchpatch {
              url = "https://github.com/Mic92/dotfiles/raw/c2f538934d67417941f83d8bb65b8263c43d32ca/home-manager/pkgs/atuin/0001-make-atuin-on-zfs-fast-again.patch";
              hash = "sha256-i0kBQPr/oubW3i/BaAXx2CQx2OMN+iIAIGhz60+Qft8=";
            })
          ];
        });

    flags = [ "--disable-up-arrow" ];

    settings = {
      enter_accept = false;
      filter_mode = "directory";
      inline_height = 30;
      style = "compact";
      update_check = false;
      daemon.enabled = true;
      local_timeout = 15;
    };
  };

  systemd.user.services.atuin = lib.mkIf (lib.versionAtLeast pkgs.atuin.version "18.3.0") {
    Unit = {
      PartOf = [ "default.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe config.programs.atuin.package} daemon";
      Restart = "on-abort";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
