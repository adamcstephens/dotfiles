{config, ...}: {
  home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/hyprland";

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}
