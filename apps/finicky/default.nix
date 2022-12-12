{config, ...}: {
  home.file.".finicky.js".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/finicky/finicky.js";
}
