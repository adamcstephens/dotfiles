{
  layer = "top";
  position = "top";
  height = 30;
  "modules-left" = [
    "sway/workspaces"
    "sway/mode"
    "river/tags"
  ];
  "modules-center" = [
  ];
  "modules-right" = [
    "tray"
    "idle_inhibitor"
    "bluetooth"
    "network"
    "battery"
    "pulseaudio"
    "clock"
  ];
  "sway/mode" = {
    format = " {}";
  };
  "sway/workspaces" = {
    "disable-scroll" = true;
    "all-outputs" = true;
    format = "{icon}";
    "format-icons" = {
      "1" = "";
      "2" = "";
      "3" = "";
      "4" = "";
      "urgent" = "";
      "focused" = "";
      "default" = "";
    };
  };
  "river/tags" = {
    "num-tags" = 5;
  };
  "idle_inhibitor" = {
    format = "{icon}";
    "format-icons" = {
      activated = "﯈";
      deactivated = "";
    };
  };
  tray = {
    spacing = 10;
  };
  clock = {
    interval = 60;
    format = "{:%m/%d @ %H:%M}";
    "max-length" = 25;
  };
  battery = {
    states = {
      warning = 35;
      critical = 20;
    };
    format = "{capacity}% {icon}";
    "format-charging" = "";
    "format-plugged" = "";
    "tooltip-format" = "{capacity}% {time}";
    "format-icons" = [
      ""
      ""
      ""
      ""
      ""
    ];
  };
  bluetooth = {
    format = "{icon}";
    "format-icons" = {
      enabled = "";
      disabled = "";
    };
    "tooltip-format" = "{}";
    "on-click" = "blueberry";
  };
  network = {
    "format-wifi" = "";
    "format-ethernet" = "";
    "format-linked" = "";
    "format-disconnected" = "⚠";
    "tooltip-format" = "{ifname} {essid} ({signalStrength}%)";
    tooltip = true;
    "on-click" = "nm-connection-editor";
  };
  pulseaudio = {
    format = "{icon}";
    "format-alt" = "{volume} {icon}";
    "format-alt-click" = "click-right";
    "format-muted" = "婢";
    "format-icons" = {
      "headphones" = "";
      "handsfree" = "";
      "headset" = "";
      "phone" = "";
      "portable" = "";
      "car" = "";
      "default" = ["" "" ""];
    };
    "scroll-step" = 10;
    "on-click" = "pavucontrol";
    tooltip = false;
  };
}