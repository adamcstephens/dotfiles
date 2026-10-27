{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.services.home-manager-adam.serviceConfig.ExecStartPre = lib.mkBefore [
    "+${pkgs.writeShellScript "dotfiles-migrate-hjem-integrated" ''
      set -euo pipefail
      if [[ -v DRY_RUN ]]; then
        exit 0
      fi
      export HOME=${lib.escapeShellArg config.home-manager.users.adam.home.homeDirectory}
      export PATH=${lib.makeBinPath [ pkgs.bash pkgs.coreutils pkgs.jq pkgs.just ]}
      exec ${pkgs.just}/bin/just \
        --shell ${pkgs.bash}/bin/bash \
        --justfile ${./../justfile} \
        --working-directory "$HOME" \
        migrate-hjem /var/lib/hjem/manifest-adam.json /var/lib/hjem/gc-roots-adam
    ''}"
  ];
}
