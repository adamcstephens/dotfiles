{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../apps/kitty
    ../apps/finicky
    ../apps/karabiner
    ../apps/vscode
  ];

  home.packages = [
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.iftop
    pkgs.mas
    pkgs.pinentry_mac

    # for class
    pkgs.nodejs

    pkgs.execline
    pkgs.s6

    pkgs.element-desktop
  ];

  home.activation.enable-ssh-agent = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    launchctl start com.openssh.ssh-agent
  '';

  launchd = {
    agents.s6 = {
      enable = true;
      config = {
        EnvironmentVariables = {
          PATH = "/run/current-system/sw/bin:${config.home.homeDirectory}/.nix-profile/bin";
        };
        KeepAlive = true;
        ProgramArguments = [
          "${pkgs.s6}/bin/s6-svscan"
          "${config.home.homeDirectory}/.dotfiles/apps/s6/service"
        ];
        RunAtLoad = true;
        StandardErrorPath = "${config.home.homeDirectory}/.cache/s6/log/s6-stderr";
        StandardOutPath = "${config.home.homeDirectory}/.cache/s6/log/s6-stdout";
      };
    };
  };
}
