{...}: {
  xdg.configFile."kanshi/config".source = ../../apps/kanshi.conf;
  services.kanshi = {
    enable = true;
  };

  systemd.user.services.kanshi = {
    Install = {
      WantedBy = ["river-session.target"];
    };
  };
}
