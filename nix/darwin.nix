{pkgs, ...}: {
  # services.emacs.package = pkgs.emacsNativeComp;
  # services.emacs.enable = true;

  home.packages = [
  ];
  programs.emacs = {
    enable = true;
    # package = pkgs.emacsNativeComp;
  };
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
  };
}
