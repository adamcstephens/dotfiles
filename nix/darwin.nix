{pkgs, ...}: {
  programs.doom-emacs = {
    emacsPackage = pkgs.emacsNativeComp;
  };
}
