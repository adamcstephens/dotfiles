{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.emacs;

  aspell = pkgs.aspellWithDicts (
    dicts: with dicts; [
      en
      en-computers
      en-science
    ]
  );

  extraBins =
    [
      pkgs.biome
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
      pkgs.pandoc
      pkgs.python3Packages.weasyprint
    ]);

  emacsPatched = cfg.package.overrideAttrs (
    prev: {
      patches =
        [ ./silence-pgtk-xorg-warning.patch ]
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

  selectedPackage = if cfg.patchForGui then emacsPatched else cfg.package;

  revealjs = pkgs.callPackage ./revealjs.nix { };

  env = ''
    (setq exec-path (append exec-path '( ${
      lib.concatMapStringsSep " " (x: ''"${x}/bin"'') extraBins
    } )))

    (defun dot/font-mono ()
      "${config.dotfiles.gui.font.mono}")

    (defun dot/font-variable ()
      "${config.dotfiles.gui.font.variable}")

    ${lib.optionalString cfg.full ''(setq org-re-reveal-root "${revealjs.outPath}")''}

    (provide 'dotemacs-nix-env)
  '';

  emacsPackages =
    epkgs:
    [
      (epkgs.trivialBuild {
        pname = "dotemacs-nix-env";
        src = pkgs.writeText "dotemacs-nix-env.el" env;
        version = "0.1.0";
      })
      epkgs.treesit-grammars.with-all-grammars
    ]
    ++ (with epkgs.melpaStablePackages; [ org-re-reveal ])
    ++ (with epkgs.melpaPackages; [
      agenix
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
      evil
      evil-collection
      evil-commentary
      evil-org
      expand-region
      fish-mode
      flyspell-correct
      gcmh
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
      nushell-ts-mode
      olivetti
      orderless
      org-appear
      org-autolist
      org-download
      org-present
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
    ])
    ++ (with epkgs.elpaPackages; [
      corfu
      org
      rainbow-mode
      substitute
      vertico
      vundo
    ])
    ++ (with epkgs.nongnuPackages; [ eat ]);

  emacsPackage = (pkgs.emacsPackagesFor selectedPackage).emacsWithPackages emacsPackages;

  package =
    let
      path = "${lib.makeBinPath extraBins}:${config.home.homeDirectory}/.dotfiles/bin";
      args = "${lib.optionalString cfg.full "--set FONTCONFIG_FILE ${config.dotfiles.gui.font.fontconfig}"} --prefix PATH : ${path}";
    in
    pkgs.symlinkJoin {
      name = "dotemacs";

      paths = [ emacsPackage ];

      nativeBuildInputs = [ pkgs.makeWrapper ];

      postBuild = ''
        wrapProgram "$out/bin/emacs" ${args}
        ${lib.optionalString pkgs.stdenv.isDarwin ''
          wrapProgram "$out/Applications/Emacs.app/Contents/MacOS/Emacs" ${args}
        ''}
      '';

      inherit (emacsPackage) meta;
    };
in
{
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
    home.packages = [ package ];

    xdg.configFile =
      if config.dotfiles.nixosManaged then
        {
          "emacs/elisp".source = ./elisp;
          "emacs/snippets".source = ./snippets;
          "emacs/custom.el".source = ./custom.el;
          "emacs/early-init.el".source = ./early-init.el;
          "emacs/init.el".source = ./init.el;
          "emacs/straight/versions/default.el".source = ./straight/versions/default.el;
        }
      else
        {
          "emacs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs";
        };

    services = lib.mkIf pkgs.stdenv.isLinux {
      emacs = {
        enable = true;
        extraOptions = [
          "--init-directory"
          "${config.home.homeDirectory}/.config/emacs"
        ];
        package = package;
        socketActivation.enable = config.dotfiles.nixosManaged;
      };
    };

    systemd = lib.mkIf pkgs.stdenv.isLinux {
      user.services.emacs.Service = {
        Environment = [ "SSH_AUTH_SOCK=%t/yubikey-agent/yubikey-agent.sock" ];
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
            "${package}/bin/emacs --fg-daemon --init-directory ${config.home.homeDirectory}/.config/emacs"
          ];
          RunAtLoad = true;
          StandardErrorPath = "${config.home.homeDirectory}/.config/emacs/launchd.log";
          StandardOutPath = "${config.home.homeDirectory}/.config/emacs/launchd.log";
          WatchPaths = [ "${config.home.homeDirectory}/.nix-profile/bin/emacs" ];
        };
      };
    };
  };
}
