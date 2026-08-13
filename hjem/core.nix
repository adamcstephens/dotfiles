{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  imports = [
    ./options.nix

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
    # TODO HM module ../apps/nix
    ../apps/ripgrep
    ../apps/shellcheck
    # TODO of course ../apps/sower
    ../apps/ssh
    ../apps/starship
    ../apps/tmux
    ../apps/tmuxinator
    ../apps/zsh
  ];

  config = lib.mkMerge [
    {
      environment.sessionVariables = {
        DO_NOT_TRACK = "true";
        EDITOR = "${config.directory}/.dotfiles/bin/editor";
        PAGER = "${config.directory}/.dotfiles/bin/pager";
        XDG_DATA_DIRS = lib.concatStringsSep ":" [
          "${config.directory}/.local/state/hjem/standalone/current-profile/share"
          "${config.directory}/.local/state/nix/profile/share"
          "${config.directory}/.nix-profile/share"
          "${config.directory}/.local/share/flatpak/exports/share"
          "/run/current-system/sw/share"
        ];
      };

      packages = [
        pkgs.difftastic
        pkgs.doggo
        pkgs.dua
        pkgs.dust
        pkgs.eza
        pkgs.file
        pkgs.fzf
        pkgs.gdu
        pkgs.gojq
        pkgs.jless
        pkgs.just
        pkgs.kitty.terminfo
        pkgs.python314
        pkgs.tio
        pkgs.wget
        pkgs.zoxide
      ]
      ++ lib.optionals (pkgs.stdenv.isLinux && (!config.dotfiles.gui.enable)) [
        pkgs.ghostty.terminfo
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        pkgs.ghostty-bin.terminfo
      ];
    }
    (lib.optionalAttrs (lib.hasAttr "systemd" options) {
      xdg.config.files."environment.d/90-hjem.conf".text =
        config.environment.sessionVariables
        |> lib.mapAttrsToList (
          name: value:
          ''${name}="${
            if lib.isList value then lib.concatMapStringsSep ":" toString value else toString value
          }"''
        )
        |> lib.concatLines;

      # systemd.services = lib.mkIf (!config.dotfiles.nixosManaged) {
      #   dotfiles-repo-pull = {
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
    })
  ];
}
