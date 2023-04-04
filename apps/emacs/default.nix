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
    pkgs.diffutils
    pkgs.fd
    pkgs.git
    pkgs.texlive.combined.scheme-full
    pkgs.graphicsmagick
    pkgs.multimarkdown
    pkgs.nodejs
    pkgs.nodePackages.mermaid-cli
    pkgs.nodePackages.prettier
    pkgs.ripgrep
    pkgs.pandoc
    pkgs.python3Minimal
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.sqlite
  ];

  emacsPackage = pkgs.emacsGit.overrideAttrs (_: {
    name = "emacs29";
    version = "29.0-${inputs.emacs-src.shortRev}";
    src = inputs.emacs-src;
  });

  emacsWithPackages = (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]);

  fontconfig_file = pkgs.makeFontsConf {
    fontDirectories = [
      "/Library/Fonts"
      pkgs.emacs-all-the-icons-fonts
      pkgs.jetbrains-mono
      pkgs.manrope
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro
    ];
  };

  package = pkgs.symlinkJoin {
    name = "dotemacs";

    paths = [
      emacsWithPackages
    ];

    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild =
      ''
        wrapProgram "$out/bin/emacs" --set TERM xterm-emacs --set FONTCONFIG_FILE ${fontconfig_file} --prefix PATH : ${lib.makeBinPath extraBins}:${config.home.homeDirectory}/.dotfiles/bin
        wrapProgram "$out/bin/emacsclient" --set TERM xterm-emacs
      ''
      + (
        if pkgs.stdenv.isDarwin
        then ''
          wrapProgram "$out/Applications/Emacs.app/Contents/MacOS/Emacs" --set FONTCONFIG_FILE ${fontconfig_file} --prefix PATH : ${lib.makeBinPath extraBins}
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
in {
  home.file.".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/doom.d";
  home.file.".config/emacs/dotemacs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/dotemacs";

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
        "${config.home.homeDirectory}/.config/emacs/dotemacs"
      ];
    };
  };

  systemd = lib.mkIf pkgs.stdenv.isLinux {
    user.services.emacs.Service.Environment = [
      "TERM=xterm-emacs"

      "SSH_AUTH_SOCK=%t/ssh-agent"
    ];
  };

  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    agents.emacs = {
      enable = true;
      config = {
        KeepAlive = true;
        RunAtLoad = true;
        ProgramArguments = [
          "${config.home.homeDirectory}/.nix-profile/bin/fish"
          "-l"
          "-c"
          "${package}/bin/emacs --fg-daemon --init-directory ${config.home.homeDirectory}/.config/emacs/dotemacs"
        ];
        WatchPaths = [
          "${config.home.homeDirectory}/.nix-profile/bin/emacs"
        ];
      };
    };
  };
}
