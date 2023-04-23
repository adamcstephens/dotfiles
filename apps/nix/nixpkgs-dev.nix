{
  lib,
  pkgs,
  ...
}: let
  script = pkgs.writeScript "ramclone-nixpkgs" ''
    #!${pkgs.bash}/bin/bash
    export PATH=${lib.makeBinPath [pkgs.bash pkgs.coreutils pkgs.direnv pkgs.git pkgs.rsync]}
    ${../../bin/ramclone-nixpkgs.sh} || true
  '';
in {
  systemd.user.services.ramclone-nixpkgs = {
    Unit.PartOf = ["default.target"];

    Service = {
      Type = "oneshot";
      ExecStart = "${script}";
      Restart = "no";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
