{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  aspell = pkgs.aspellWithDicts (dicts: with dicts; [en en-computers en-science]);
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) amsmath anyfontsize boxedminipage capt-of hyperref lastpage minted scheme-tetex sectsty wrapfig;
  };

  emacsPackage =
    if pkgs.stdenv.isLinux
    then pkgs.emacsGit
    else pkgs.emacsGit;

  emacsWithPackages = (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]);

  package = pkgs.symlinkJoin {
    name = "dotemacs";

    paths = [
      emacsWithPackages
    ];

    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/emacs" --set TERM xterm-emacs
      wrapProgram "$out/bin/emacsclient" --set TERM xterm-emacs
    '';

    inherit (pkgs.emacs) meta;
  };

  extraBins = [
    pkgs.alejandra
    aspell
    pkgs.diffutils
    pkgs.fd
    pkgs.git
    # latex
    pkgs.texlive.combined.scheme-full
    pkgs.graphicsmagick
    pkgs.nodePackages.mermaid-cli
    pkgs.ripgrep
    pkgs.pandoc
    pkgs.shellcheck
    pkgs.shfmt
  ];

  revealjs = pkgs.callPackage ./revealjs.nix {};
in {
  imports = [
    inputs.chemacs.homeModule
  ];

  home.packages = [
    aspell
    revealjs
  ];

  home.file.".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/doom.d";
  home.file.".config/chemacs/dotemacs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/dotemacs";
  home.file.".config/chemacs/default".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/dotemacs";

  programs.emacs = {
    enable = true;
    package = package;
    extraConfig = ''
      (setq exec-path (append exec-path '( ${
        lib.concatMapStringsSep " " (x: ''"${x}/bin"'') extraBins
      } )))
      (setenv "PATH" (concat (getenv "PATH") ":${
        lib.concatMapStringsSep ":" (x: "${x}/bin") extraBins
      }"))

      (setq org-re-reveal-root "${revealjs.outPath}")
    '';

    chemacs.profiles = {
      default = {};
      doom = {
        env.DOOMDIR = "~/.config/doom";
      };
      dotemacs = {};
    };
  };

  home.activation.doomemacs = lib.hm.dag.entryAfter ["linkGeneration"] ''
    export PATH=$PATH:${lib.makeBinPath [pkgs.git emacsPackage]}
    cd ~/.dotfiles
    ${pkgs.just}/bin/just doomemacs
  '';

  services.emacs.enable =
    if pkgs.stdenv.isLinux
    then true
    else false;

  systemd = lib.mkIf pkgs.stdenv.isLinux {user.services.emacs.Service.Environment = ["TERM=xterm-emacs"];};
}
