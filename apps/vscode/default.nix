{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.vscode;
  prefix = if pkgs.stdenv.isDarwin then "Library/Application Support" else ".config";
in
{
  options.dotfiles.apps.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.dotfiles.vscodium.enable;
        message = "vscodium and vscode are mutually exclusive";
      }
    ];

    home.file."${prefix}/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/keybindings.json";
    home.file."${prefix}/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/settings.json";

    # they say you shouldn't modify the system in this phase, but... 🤷‍♂️
    home.activation.own-vscode-snippets = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      if [ ! -h "${config.home.homeDirectory}/${prefix}/Code/User/snippets" ]; then
        rm -rfv "${config.home.homeDirectory}/${prefix}/Code/User/snippets"
      fi
    '';
    home.file."${prefix}/Code/User/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/snippets";

    programs.vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions; [
        github.copilot
        ms-vsliveshare.vsliveshare
      ];
    };
  };
}
