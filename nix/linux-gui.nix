{pkgs, ...}: {
  home.packages = [
    # pkgs.cider
  ];

  programs.doom-emacs = {
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };
}
