{
  config,
  lib,
  pkgs,
  ...
}:
let
  os = pkgs.hostPlatform.uname.system;
in
{
  home.packages = [
    pkgs.git
    pkgs.git-extras
  ]
  ++ lib.optionals config.dotfiles.dev.enable [
    pkgs.gh
    pkgs.lazygit
    (pkgs.writeShellScriptBin "lg" "exec ${lib.getExe pkgs.lazygit} $@")
    pkgs.forgejo-cli
  ];

  xdg.configFile = {
    "git/config".source =
      if config.dotfiles.nixosManaged then
        ./gitconfig
      else
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/git/gitconfig";

    "git/config.os".source = pkgs.writeText "git-config-${os}" ''
      [gpg "ssh"]
      defaultKeyCommand = ${config.home.homeDirectory}/.dotfiles/bin/git-ssh-key.sh
    '';

    "git/ignore".text = lib.concatStringsSep "\n" [
      "*.log"
      "*.retry"
      ".DS_Store"
      ".direnv/"
      ".lsp/"
      ".worktree/"
      "result"
      "result-*"
    ];
  };
}
