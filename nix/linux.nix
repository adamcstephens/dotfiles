{pkgs, ...}: {
  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };
}