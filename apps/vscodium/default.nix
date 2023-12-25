{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefix = if pkgs.stdenv.isDarwin then "Library/Application Support" else ".config";
in
{
  home.file."${prefix}/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/keybindings.json";
  home.file."${prefix}/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/settings.json";
  home.file."${prefix}/VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/keybindings.json";
  home.file."${prefix}/VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/settings.json";

  # they say you shouldn't modify the system in this phase, but... 🤷‍♂️
  home.activation.own-vscode-snippets = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ ! -h "${config.home.homeDirectory}/${prefix}/Code/User/snippets" ]; then
      rm -rfv "${config.home.homeDirectory}/${prefix}/Code/User/snippets"
    fi
    if [ ! -h "${config.home.homeDirectory}/${prefix}/VSCodium/User/snippets" ]; then
      rm -rfv "${config.home.homeDirectory}/${prefix}/VSCodium/User/snippets"
    fi
  '';
  home.file."${prefix}/Code/User/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/snippets";
  home.file."${prefix}/VSCodium/User/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/snippets";

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      bmalehorn.vscode-fish
      davidanson.vscode-markdownlint
      editorconfig.editorconfig
      esbenp.prettier-vscode
      foxundermoon.shell-format
      github.github-vscode-theme
      jnoortheen.nix-ide
      mkhl.direnv
      naumovs.color-highlight
      phoenixframework.phoenix
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      skellock.just
      tamasfe.even-better-toml
      thenuprojectcontributors.vscode-nushell-lang
      timonwong.shellcheck
    ];
  };
}
