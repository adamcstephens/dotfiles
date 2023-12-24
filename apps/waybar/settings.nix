{ lib }:
{
  layer = "top";
  position = "top";
  height = 30;
  modules-left = [ "river/tags" ];
  modules-center = [ ];
  modules-right = [
    "tray"
    "idle_inhibitor"
    "bluetooth"
    "network"
    "battery"
    "pulseaudio"
    "clock"
  ];
  "river/tags" = {
    num-tags = 8;
  };
  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "☕";
      deactivated = "";
    };
  };
  tray = {
    spacing = 10;
  };
  clock = {
    interval = 60;
    format = "{:%m/%d @ %H:%M}";
    max-length = 25;
  };
  battery = {
    full-at = 99;
    interval = 10;
    states = {
      warning = 35;
      critical = 20;
    };
    format = "{capacity}% {icon}";
    format-icons = {
      charging = [
        "󱊤"
        "󱊥"
        "󱊦"
      ];
      plugged = "󱟢";
      default = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };
    tooltip-format = "{capacity}% {time}";
  };
  bluetooth = {
    format = "{icon}";
    format-icons = {
      enabled = "";
      disabled = "";
    };
    tooltip-format = "{}";
    on-click = "blueberry";
  };
  network = {
    interface = lib.mkDefault "wlp0s20f3";
    format-wifi = "";
    format-ethernet = "";
    format-linked = "";
    format-disconnected = "⚠";
    tooltip-format = "{ifname} {essid} ({signalStrength}%)";
    tooltip = true;
    on-click = "nm-connection-editor";
  };
  pulseaudio = {
    format = "{icon}";
    format-alt = "{volume} {icon}";
    format-alt-click = "click-right";
    format-muted = "婢";
    format-icons = {
      headphones = "";
      handsfree = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = [
        ""
        ""
        ""
      ];
    };
    scroll-step = 10;
    on-click = "pavucontrol";
    tooltip = false;
  };
}
