{pkgs, ...}: {
  services.emacs.enable = true;

  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };
}
