{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  aspell = pkgs.aspellWithDicts (dicts: with dicts; [en en-computers en-science]);

  extraBins = [
    pkgs.alejandra
    aspell
    pkgs.clojure-lsp
    pkgs.coreutils
    pkgs.curl
    pkgs.diffutils
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.groff
    pkgs.texlive.combined.scheme-full
    pkgs.graphicsmagick
    pkgs.multimarkdown
    pkgs.nodejs
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.mermaid-cli
    pkgs.nodePackages.prettier
    pkgs.pandoc
    pkgs.python3Minimal
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.sqlite
  ];

  emacsSource = pkgs.emacs-unstable;

  emacsPatched = emacsSource.overrideAttrs (prev: {
    patches =
      # [./silence-pgtk-xorg-warning.patch]
      # ++
      (lib.optionals pkgs.stdenv.isDarwin [
        "${inputs.emacs-plus}/patches/emacs-28/fix-window-role.patch"
        "${inputs.emacs-plus}/patches/emacs-28/no-frame-refocus-cocoa.patch"
        "${inputs.emacs-plus}/patches/emacs-29/poll.patch"
        # "${inputs.emacs-plus}/patches/emacs-30/round-undecorated-frame.patch"
        "${inputs.emacs-plus}/patches/emacs-28/system-appearance.patch"
      ])
      ++ prev.patches;

    passthru =
      prev.passthru
      // {
        treeSitter = true;
      };
  });

  emacsWithPackages = (pkgs.emacsPackagesFor emacsPatched).emacsWithPackages (epkgs:
    [epkgs.treesit-grammars.with-all-grammars]
    ++ (with epkgs.melpaPackages; [
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
      haskell-mode
      hide-mode-line
      just-mode
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
      nix-mode
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
    ]));

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

    (setq org-re-reveal-root "${revealjs.outPath}")
  '';

  terminfo = pkgs.callPackage ../../packages/terminfo {};
in {
  programs.emacs = {
    enable = true;
    package = package;
    extraConfig = env;
  };

  services = lib.mkIf pkgs.stdenv.isLinux {
    emacs = {
      enable = true;
      extraOptions = [
        "--init-directory"
        "${config.home.homeDirectory}/.dotfiles/apps/emacs"
      ];
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
          "${config.programs.emacs.finalPackage}/bin/emacs --fg-daemon --init-directory ${config.home.homeDirectory}/.dotfiles/apps/emacs"
        ];
        RunAtLoad = true;
        StandardErrorPath = "${config.home.homeDirectory}/.dotfiles/apps/emacs/launchd.log";
        StandardOutPath = "${config.home.homeDirectory}/.dotfiles/apps/emacs/launchd.log";
        WatchPaths = [
          "${config.home.homeDirectory}/.nix-profile/bin/emacs"
        ];
      };
    };
  };
}
