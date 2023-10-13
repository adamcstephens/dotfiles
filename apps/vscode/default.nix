{
  config,
  lib,
  pkgs,
  ...
}: let
  prefix =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support"
    else ".config";
in {
  home.file."${prefix}/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/keybindings.json";
  home.file."${prefix}/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/settings.json";
  home.file."${prefix}/VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/keybindings.json";
  home.file."${prefix}/VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/settings.json";

  # they say you shouldn't modify the system in this phase, but... 🤷‍♂️
  home.activation.own-vscode-snippets = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    if [ ! -h "${config.home.homeDirectory}/${prefix}/Code/User/snippets" ]; then
      rm -rfv "${config.home.homeDirectory}/${prefix}/Code/User/snippets"
    fi
    if [ ! -h "${config.home.homeDirectory}/${prefix}/VSCodium/User/snippets" ]; then
      rm -rfv "${config.home.homeDirectory}/${prefix}/VSCodium/User/snippets"
    fi
  '';
  home.file."${prefix}/Code/User/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/snippets";
  home.file."${prefix}/VSCodium/User/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/snippets";

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = [
      pkgs.vscode-extensions.phoenixframework.phoenix
    ];
  };
}
