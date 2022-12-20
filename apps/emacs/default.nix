{
  lib,
  pkgs,
  ...
}: let
  aspell = pkgs.aspellWithDicts (dicts: with dicts; [en en-computers en-science]);
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-tetex amsmath capt-of hyperref wrapfig;
  };

  package = pkgs.emacs;

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
    package = package;
    extraConfig = ''
      (setq exec-path (append exec-path '( ${
        lib.concatMapStringsSep " " (x: ''"${x}/bin"'') extraBins
      } )))
      (setenv "PATH" (concat (getenv "PATH") ":${
        lib.concatMapStringsSep ":" (x: "${x}/bin") extraBins
      }"))
    '';
  };

  home.packages = [aspell];

  services.emacs.enable =
    if pkgs.stdenv.isLinux
    then true
    else false;
}
