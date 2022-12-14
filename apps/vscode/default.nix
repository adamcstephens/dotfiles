{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  pkgs-vscode = import inputs.nixpkgs-vscode {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };

  package = pkgs-vscode.vscode;
  keybindings =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/Code/User/keybindings.json"
    else ".config/Code/User/keybindings.json";
  settings =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/Code/User/settings.json"
    else ".config/Code/User/settings.json";
in {
  home.file."${keybindings}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/keybindings.json";
  home.file."${settings}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscode/settings.json";

  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    package
  ];

  programs.vscode = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = package;
  };
}
