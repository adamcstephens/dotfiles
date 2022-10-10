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
    pkgs.git
    latex
    pkgs.graphicsmagick
    pkgs.nil
    pkgs.shellcheck
    pkgs.shfmt
  ];
in {
  programs.emacs = {
    enable = true;
    # package = pkgs.emacsNativeComp;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
    extraConfig = ''
      (setq exec-path (append exec-path '( ${
        lib.concatMapStringsSep " " (x: ''"${x}/bin"'') extraBins
      } )))
      (setenv "PATH" (concat (getenv "PATH") ":${
        lib.concatMapStringsSep ":" (x: "${x}/bin") extraBins
      }"))
    '';
  };

  services.emacs.enable =
    if pkgs.stdenv.isLinux
    then true
    else false;
}
