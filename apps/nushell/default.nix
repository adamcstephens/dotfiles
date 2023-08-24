{...}: {
  programs.nushell = {
    enable = true;

    configFile = {
      text = ''
        alias cat = bat
        alias esl = exec nu -l
        alias ll = ls -l
        alias l = ll -a
        alias nix = nix --print-build-logs
        alias dog = doggo

        $env.config = {
          show_banner: false,
        }

      '';
    };
  };
}
