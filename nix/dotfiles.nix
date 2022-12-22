{lib, ...}: {
  options.dotfiles = {
    linuxGui = lib.mkEnableOption "linuxGui";
    isVM = lib.mkEnableOption "isVM";

    repo = lib.mkOption {
      type = lib.types.str;
      default = "https://codeberg.org/adamcstephens/dotfiles";
    };

    gui = {
      dpi = lib.mkOption {
        type = lib.types.int;
        default = 96;
      };

      font = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
      };
    };
  };
}
