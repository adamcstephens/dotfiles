{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;

    configFile = {
      text = ''
        source ~/.zoxide.nu

        alias cat = bat
        alias esl = exec nu -l
        alias ll = ls -l
        alias l = ll -a
        alias nix = nix --print-build-logs
        alias dog = doggo
      '';
    };

    envFile = {
      text = ''
        ${lib.getExe pkgs.zoxide} init --cmd j nushell | save -f ~/.zoxide.nu
      '';
    };
  };
}
