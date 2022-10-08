{...}: {
  xdg.configFile."dunst/dunstrc".source = ./dunstrc;

  services.dunst.enable = true;

  systemd.user.services.dunst = {
    Install = {
      WantedBy = ["river-session.target"];
    };
  };
}
