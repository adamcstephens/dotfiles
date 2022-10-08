{...}: {
  xdg.configFile."river/init".source = ./river.sh;

  systemd.user.targets.river-session = {
    Unit = {
      Description = "sway compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}