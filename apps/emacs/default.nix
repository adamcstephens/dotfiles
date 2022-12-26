{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  aspell = pkgs.aspellWithDicts (dicts: with dicts; [en en-computers en-science]);
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-tetex amsmath capt-of hyperref wrapfig;
  };

  package = pkgs.symlinkJoin {
    name = "dotemacs";

    paths = [
      (
        if pkgs.stdenv.isLinux
        then pkgs.emacsGit
        else pkgs.emacs
      )
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
    # pkgs.corefonts
    pkgs.fd
    pkgs.git
    latex
    pkgs.graphicsmagick
    pkgs.nodePackages.mermaid-cli
    pkgs.nil
    pkgs.ripgrep
    pkgs.pandoc
    pkgs.shellcheck
    pkgs.shfmt
  ];
in {
  imports = [
    inputs.chemacs.homeModule
  ];

  home.file.".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/doom.d";
  home.file.".config/chemacs/dotemacs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/emacs/dotemacs";

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
    '';

    chemacs.profiles = {
      default = {
        env.DOOMDIR = "~/.config/doom";
        userDir = "${config.programs.emacs.chemacs.defaultUserParentDir}/doom";
      };
      doom = {
        env.DOOMDIR = "~/.config/doom";
      };
      dotemacs = {};
    };
  };

  home.packages = [aspell];

  home.activation.doomemacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cd ~/.dotfiles
    ${pkgs.just}/bin/just doomemacs
  '';

  services.emacs.enable =
    if pkgs.stdenv.isLinux
    then true
    else false;
}
