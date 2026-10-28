{
  config,
  flake,
  lib,
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
    ../apps/sower
    ../apps/ssh
    ../apps/starship
    ../apps/tmux
    ../apps/tmuxinator
    # Disable to clear current managed dir ../apps/zellij
    ../apps/zsh
  ];

  config = {
    _module.args.dotlib = {
      source =
        relative:
        if config.dotfiles.nixosManaged then
          "${flake}/${relative}"
        else
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${relative}";

      unfreePkg =
        name: nixpkgs:
        let
          packages = nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system} or nixpkgs;
        in
        (lib.getAttrFromPath (lib.toList name) packages).overrideAttrs (old: {
          meta = old.meta // {
            license = [ ];
          };
        });
    };

    home.stateVersion = "26.05";
    xdg.enable = true;

    home.activation.dotfiles-migrate = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      run ${pkgs.coreutils}/bin/env \
        PATH=${lib.makeBinPath [ pkgs.bash pkgs.coreutils pkgs.jq pkgs.just ]} \
        ${pkgs.just}/bin/just \
        --shell ${pkgs.bash}/bin/bash \
        --justfile ${../justfile} \
        --working-directory ${lib.escapeShellArg config.home.homeDirectory} \
        migrate
    '';

    xdg.configFile."home-manager/session-env.sh".text = ''
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      export PATH="${config.home.profileDirectory}/bin:${config.home.profileDirectory}/sbin:$PATH"
    '';

    home.sessionVariables = {
      DO_NOT_TRACK = "true";
      EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
      PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_DATA_DIRS = "${config.home.profileDirectory}/share:\${XDG_DATA_DIRS}";
    };

    home.packages = [
      flake.packages.${pkgs.stdenv.hostPlatform.system}.dotfiles

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
      pkgs.osc
      pkgs.python314
      pkgs.tio
      pkgs.wget
      pkgs.zoxide
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux && (!config.dotfiles.gui.enable)) [
      pkgs.ghostty.terminfo
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      pkgs.ghostty-bin.terminfo
    ];
  };
}
