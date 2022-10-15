{...}: {
  services.dunst.enable = true;
  services.dunst.configFile = "%h/.dotfiles/apps/dunst/dunstrc";

  systemd.user.services.dunst = {
    Install = {
      WantedBy = ["river-session.target"];
    };
  };
}
