{
  config,
  lib,
  pkgs,
  ...
}: let
  # pkgs-vscode = import inputs.nixpkgs-vscode {
  #   inherit (pkgs) system;
  #   config.allowUnfree = true;
  # };
  package = pkgs.vscode;

  prefix =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/Code/User"
    else ".config/Code/User";
in {
  home.file."${prefix}/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/keybindings.json";
  home.file."${prefix}/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/settings.json";

  # they say you shouldn't modify the system in this phase, but... 🤷‍♂️
  home.activation.own-vscode-snippets = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    if [ ! -h "${config.home.homeDirectory}/${prefix}/snippets" ]; then
      rm -rfv "${config.home.homeDirectory}/${prefix}/snippets"
    fi
  '';
  home.file."${prefix}/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/snippets";

  home.packages = [
    package
  ];

  programs.vscode = {
    enable = true;
    package = package;
  };
}
