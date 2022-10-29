{
  lib,
  pkgs,
  ...
}: let
  aspell =
    pkgs.aspellWithDicts (dicts: with dicts; [en en-computers en-science]);
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-tetex amsmath capt-of hyperref wrapfig;
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
  programs.emacs = {
    enable = true;
    # package = pkgs.emacsNativeComp;
    extraConfig = ''
      (setq exec-path (append exec-path '( ${
        lib.concatMapStringsSep " " (x: ''"${x}/bin"'') extraBins
      } )))
      (setenv "PATH" (concat (getenv "PATH") ":${
        lib.concatMapStringsSep ":" (x: "${x}/bin") extraBins
      }"))
    '';
  };

  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom.d;
  #   # package dir is use for buildng the straight package, so we can skip rebuilds on config changes
  #   doomPackageDir = pkgs.linkFarm "dotfiles-doom-packages" [
  #     {
  #       name = "config.el";
  #       path = pkgs.emptyFile;
  #     }
  #     {
  #       name = "init.el";
  #       path = ./doom.d/init.el;
  #     }
  #     {
  #       name = "packages.el";
  #       path = ./doom.d/packages.el;
  #     }
  #   ];
  # };

  services.emacs.enable =
    if pkgs.stdenv.isLinux
    then true
    else false;
}
