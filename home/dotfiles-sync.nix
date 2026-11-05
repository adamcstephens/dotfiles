{
  config,
  lib,
  pkgs,
  ...
}:
let
  sync = pkgs.writeShellApplication {
    name = "dotfiles-sync";
    runtimeInputs = [
      pkgs.git
      pkgs.jujutsu
      pkgs.python3
    ];
    text = ''
      export PATH=${lib.escapeShellArg "${config.home.homeDirectory}/.dotfiles/bin"}:"$PATH"
      if [[ -d .jj ]]; then
        exec jj home --rebase
      else
        exec git pull --ff-only
      fi
    '';
  };
in
lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !config.dotfiles.nixosManaged) {
  systemd.user = {
    services.dotfiles-sync = {
      Unit.Description = "Sync the dotfiles checkout";
      Service = {
        Type = "oneshot";
        WorkingDirectory = "%h/.dotfiles";
        ExecStart = lib.getExe sync;
      };
    };

    timers.dotfiles-sync = {
      Unit.Description = "Sync the dotfiles checkout daily";
      Timer = {
        OnCalendar = "daily";
        RandomizedDelaySec = "1h";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };

  home.activation.dotfiles-sync = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
    if ${config.systemd.user.systemctlPath} --user --quiet is-active default.target; then
      run ${config.systemd.user.systemctlPath} --user --no-block start dotfiles-sync.service
    fi
  '';
}
