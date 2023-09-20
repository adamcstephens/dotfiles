{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.apps.emacs;

  aspell = pkgs.aspellWithDicts (dicts: with dicts; [en en-computers en-science]);

  extraBins =
    [
      pkgs.alejandra
      pkgs.coreutils
      pkgs.curl
      pkgs.diffutils
      pkgs.fd
      pkgs.fzf
      pkgs.git
      pkgs.python3Minimal
      pkgs.ripgrep
      pkgs.shellcheck
      pkgs.shfmt
      pkgs.sqlite
    ]
    ++ (lib.optionals cfg.full [
      aspell
      pkgs.ghostscript
      pkgs.groff
      pkgs.graphicsmagick
      pkgs.multimarkdown
      pkgs.nodejs
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.prettier
      pkgs.pandoc
      pkgs.python3Packages.weasyprint
    ]);

  emacsPatched = cfg.package.overrideAttrs (
    prev: {
      patches =
        [./silence-pgtk-xorg-warning.patch]
        ++ (lib.optionals pkgs.stdenv.isDarwin [
          "${inputs.emacs-plus}/patches/emacs-28/fix-window-role.patch"
          "${inputs.emacs-plus}/patches/emacs-28/no-frame-refocus-cocoa.patch"
          "${inputs.emacs-plus}/patches/emacs-29/poll.patch"
          # "${inputs.emacs-plus}/patches/emacs-30/round-undecorated-frame.patch"
          "${inputs.emacs-plus}/patches/emacs-28/system-appearance.patch"
        ])
        ++ prev.patches;
    }
  );

  emacsWithPackages =
    (pkgs.emacsPackagesFor (
      if cfg.patchForGui
      then emacsPatched
      else cfg.package
    ))
    .emacsWithPackages
    (
      epkgs:
        [epkgs.treesit-grammars.with-all-grammars]
        ++ (
          with epkgs.melpaPackages; [
            all-the-icons
            apheleia
            auto-dark
            avy
            bbww
            cape
            chatgpt-shell
            cider
            clipetty
            consult
            dash
            diff-ansi
            diff-hl
            direnv
            dirvish
            doom-modeline
            editorconfig
            eldoc-box
            elisp-autofmt
            elixir-ts-mode
            embark
            embark-consult
            expand-region
            fish-mode
            flyspell-correct
            git-auto-commit-mode
            golden-ratio
            haskell-mode
            hide-mode-line
            just-mode
            kkp
            ligature
            lispy
            magit
            marginalia
            markdown-mode
            modus-themes
            move-dup
            multi-vterm
            mwim
            nim-mode
            nix-ts-mode
            nushell-mode
            olivetti
            orderless
            org-appear
            org-autolist
            org-download
            org-present
            org-re-reveal
            org-superstar
            ox-pandoc
            persistent-scratch
            project-rootfile
            rainbow-delimiters
            ron-mode
            run-command
            ssh-config-mode
            terraform-mode
            transpose-frame
            treesit-auto
            undo-fu
            undo-fu-session
            vterm
            wgrep
            which-key
            whole-line-or-region
            yasnippet
            yasnippet-snippets
            yuck-mode
          ]
        )
        ++ (
          with epkgs.elpaPackages; [
            corfu
            org
            rainbow-mode
            substitute
            vertico
            vundo
          ]
        )
        ++ (with epkgs.nongnuPackages; [eat])
    );

  package = pkgs.symlinkJoin {
    name = "dotemacs";

    paths = [
      emacsWithPackages
    ];

    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild =
      ''
        wrapProgram "$out/bin/emacs" --set TERM xterm-emacs --set FONTCONFIG_FILE ${config.dotfiles.gui.font.fontconfig} --prefix PATH : ${lib.makeBinPath extraBins}:${config.home.homeDirectory}/.dotfiles/bin
        wrapProgram "$out/bin/emacsclient" --set TERM xterm-emacs
      ''
      + (
        if pkgs.stdenv.isDarwin
        then ''
          wrapProgram "$out/Applications/Emacs.app/Contents/MacOS/Emacs" --set FONTCONFIG_FILE ${config.dotfiles.gui.font.fontconfig} --prefix PATH : ${lib.makeBinPath extraBins}
        ''
        else ""
      );

    inherit (pkgs.emacs) meta;
  };

  revealjs = pkgs.callPackage ./revealjs.nix {};

  env = ''
    (setq exec-path (append exec-path '( ${lib.concatMapStringsSep " " (x: ''"${x}/bin"'') extraBins} )))

    ${lib.optionalString cfg.full ''(setq org-re-reveal-root "${revealjs.outPath}")''}
  '';

  terminfo = pkgs.callPackage ../../packages/terminfo {};
in {
  options = {
    dotfiles.apps.emacs = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.emacs29;
      };

      patchForGui = lib.mkEnableOption "patch emacs as if for a gui install";

      full = lib.mkEnableOption "install the full set of tools, as if a workstation";
    };
  };
  config = {
    programs.emacs = {
      enable = true;
      package = package;
      extraConfig = env;
    };

    xdg.configFile =
      if config.dotfiles.nixosManaged
      then {
        "emacs/elisp".source = ./elisp;
        "emacs/snippets".source = ./snippets;
        "emacs/custom.el".source = ./custom.el;
        "emacs/early-init.el".source = ./early-init.el;
        "emacs/init.el".source = ./init.el;
        "emacs/straight/versions/default.el".source = ./straight/versions/default.el;
      }
      else {
        "emacs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs";
      };

    services = lib.mkIf pkgs.stdenv.isLinux {
      emacs = {
        enable = true;
        extraOptions = [
          "--init-directory"
          "${config.home.homeDirectory}/.config/emacs"
        ];
        socketActivation.enable = config.dotfiles.nixosManaged;
      };
    };

    systemd = lib.mkIf pkgs.stdenv.isLinux {
      user.services.emacs.Service = {
        Environment = [
          "TERMINFO=${terminfo}/share/terminfo"
          "TERM=xterm-emacs"

          "SSH_AUTH_SOCK=%t/yubikey-agent/yubikey-agent.sock"
        ];
        TimeoutSec = 900;
      };
    };

    launchd = lib.mkIf pkgs.stdenv.isDarwin {
      agents.emacs = {
        enable = true;
        config = {
          KeepAlive = true;
          ProgramArguments = [
            "${config.home.homeDirectory}/.nix-profile/bin/fish"
            "-l"
            "-c"
            "${config.programs.emacs.finalPackage}/bin/emacs --fg-daemon --init-directory ${config.home.homeDirectory}/.config/emacs"
          ];
          RunAtLoad = true;
          StandardErrorPath = "${config.home.homeDirectory}/.config/emacs/launchd.log";
          StandardOutPath = "${config.home.homeDirectory}/.config/emacs/launchd.log";
          WatchPaths = [
            "${config.home.homeDirectory}/.nix-profile/bin/emacs"
          ];
        };
      };
    };
  };
}
