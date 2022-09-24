{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    # package = pkgs.emacsNativeComp;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
  };

  services.emacs.enable =
    if pkgs.stdenv.isLinux
    then true
    else false;
}
