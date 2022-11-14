{lib, ...}: {
  options.dotfiles = {
    linuxGui = lib.mkEnableOption "linuxGui";
    isVM = lib.mkEnableOption "isVM";
  };
}
