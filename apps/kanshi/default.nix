{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."kanshi/config".source = ./kanshi.conf;

  services.kanshi = {
    enable = true;
  };

  systemd.user.services.kanshi = {
    Install = {
      WantedBy = ["river-session.target"];
    };
    Service = {
      Environment = ["PATH=${config.programs.eww.package}/bin:$PATH"];
    };
  };
}
