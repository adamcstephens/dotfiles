{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./options.nix

    # ../apps/bash
    ../apps/bat
    ../apps/btop
    ../apps/delta
    ../apps/direnv
    # TODO HM module ../apps/editorconfig
    ../apps/fd
    ../apps/fish
    ../apps/git
    ../apps/helix
    ../apps/jjui
    ../apps/jujutsu
    ../apps/neovim
    # TODO HM module ../apps/nix
    ../apps/ripgrep
    ../apps/shellcheck
    # TODO of course ../apps/sower
    ../apps/ssh
    ../apps/starship
    ../apps/tmux
    ../apps/tmuxinator
    # ../apps/wayland
    ../apps/zsh
  ];

  # TODO can be replaced by clobber?
  # home.activation.dotfiles-migrate = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
  #   ${lib.getExe pkgs.just} --justfile ${../justfile} migrate
  # '';

  files = {
    # TODO can't manage these like this, how to auto-create?
    # git.type = "directory";
    # projects.type = "directory";
    # tmp.type = "directory";

    ".terminfo".source = "${config.directory}/share/terminfo";
  };

  # TODO no options on darwin
  # systemd = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  #   services.dotfiles-repo-pull = {
  #     wantedBy = [ "default.target" ];
  #     partOf = [ "default.target" ];
  #     startAt = "hourly";
  #
  #     serviceConfig = {
  #       Type = "oneshot";
  #       ExecStart =
  #         pkgs.writeShellApplication {
  #           name = "dotfiles-repo-pull";
  #
  #           runtimeInputs = [
  #             pkgs.git
  #             pkgs.jujutsu
  #           ];
  #
  #           text = ''
  #             export PATH=${../bin}:$PATH
  #
  #             if [ -h .dotfiles ]; then
  #               echo "Refusing to overwrite dotfiles link"
  #               exit 1
  #             fi
  #
  #             if [ ! -e .dotfiles ]; then
  #               git clone https://codeberg.org/adamcstephens/dotfiles.git .dotfiles
  #             fi
  #
  #             cd .dotfiles
  #
  #             if [ -d .jj ]; then
  #               jj home -r
  #             else
  #               git pull
  #             fi
  #           '';
  #         }
  #         |> lib.getExe;
  #
  #       WorkingDirectory = config.directory;
  #     };
  #   };
  # };

  packages = [
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
    pkgs.wget
    pkgs.zoxide
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.ghostty.terminfo
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.ghostty-bin.terminfo
  ];

  environment.sessionVariables = {
    DO_NOT_TRACK = "true";
    EDITOR = "${config.directory}/.dotfiles/bin/editor";
    PAGER = "${config.directory}/.dotfiles/bin/pager";
  };
}
