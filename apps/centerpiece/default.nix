{ pkgs, ... }:
{
  packages = [ pkgs.centerpiece ];

  xdg.config.files."centerpiece/config.yml".text = builtins.toJSON {
    plugin = {
      applications.enable = true;
      brave_bookmarks.enable = false;
      brave_history.enable = false;
      brave_progressive_web_apps.enable = false;

      git_repositories = {
        enable = true;
        zoxide = true;
        commands = [
          [
            "prj"
            "$GIT_DIRECTORY"
          ]
        ];
      };

      resource_monitor_battery.enable = false;
      resource_monitor_cpu.enable = false;
      resource_monitor_disks.enable = false;
      resource_monitor_memory.enable = false;

      system.enable = true;

      sway_windows.enable = false;
      wifi.enable = false;
    };
  };
}
