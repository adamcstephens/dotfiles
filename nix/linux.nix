{pkgs, ...}: {
  # services.emacs.package = pkgs.emacsNativeComp;
  # services.emacs.enable = true;

  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };
}
