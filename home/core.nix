{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./module.nix

    ../apps/bash
    ../apps/bat
    ../apps/btop
    ../apps/delta
    ../apps/direnv
    ../apps/editorconfig
    ../apps/fd
    ../apps/fish
    ../apps/git
    ../apps/helix
    ../apps/jjui
    ../apps/jujutsu
    ../apps/neovim
    ../apps/nix
    ../apps/ripgrep
    ../apps/shellcheck
    ../apps/ssh
    ../apps/starship
    ../apps/tmux
    ../apps/tmuxinator
    ../apps/wayland
    ../apps/zellij
    ../apps/zsh
  ];

  home.stateVersion = "22.05";

  home.activation.dotfiles-migrate = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    ${lib.getExe pkgs.just} --justfile ${../justfile} migrate
  '';

  home.activation.directories = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for dir in git projects tmp; do
      if [ ! -d $HOME/$dir ]; then
        mkdir -vp $HOME/$dir
      fi
    done
  '';

  systemd.user = lib.mkIf (!config.dotfiles.nixosManaged) {
    services.dotfiles-repo-pull = {
      Unit = {
        PartOf = [ "default.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart =
          pkgs.writeShellApplication {
            name = "dotfiles-repo-pull";

            runtimeInputs = [
              pkgs.git
              pkgs.jujutsu
            ];

            text = ''
              export PATH=${../bin}:$PATH

              if [ -d .jj ]; then
                jj home -r
              else
                git pull
              fi
            '';
          }
          |> lib.getExe;

        WorkingDirectory = "${config.home.homeDirectory}/.dotfiles";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    timers.dotfiles-repo-pull = {
      Timer.OnCalendar = "hourly";
      Install.WantedBy = [ "timers.target" ];
    };
  };

  home.file.".terminfo".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.profileDirectory}/share/terminfo";

  home.packages = [
    pkgs.difftastic
    pkgs.doggo
    pkgs.dust
    pkgs.eza
    pkgs.file
    pkgs.fzf
    pkgs.gdu
    pkgs.gojq
    pkgs.jless
    pkgs.just
    pkgs.kitty.terminfo
    pkgs.ncdu
    pkgs.python314
    pkgs.tio
    pkgs.viddy
    pkgs.wget
    pkgs.zoxide
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.ghostty.terminfo
  ];

  home.sessionVariables = {
    EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
    PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
}
