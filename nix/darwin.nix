{pkgs, ...}: {
  # services.emacs.package = pkgs.emacsNativeComp;
  # services.emacs.enable = true;

  home.packages = [
    pkgs.emacsNativeComp
  ];
}
