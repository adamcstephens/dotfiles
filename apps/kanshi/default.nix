# right offests
#   1.00, 3840 x 2160
#   1.25, 3072 x 864
#   1.28, 3000 x 843.75
#   1.32, 2909.091 x 818.1819
#   1.35, 2844.4443 x 800
#   1.40, 2742.8571 x 1542.8571

{
  config,
  pkgs,
  ...
}: let
  execs = [
    "eww reload"
    "eww open bar"
  ];
in {
  services.kanshi = {
    enable = true;
    systemdTarget = "river-session.target";
    profiles = {
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL P2715Q 54KKD79CAQNL";
            scale = 1.4;
          }
        ];

        exec = execs;
      };
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 2.2;
            status = "enable";
          }
        ];

        exec = execs;
      };
    };
  };

  systemd.user.services.kanshi = {
    Service = {
      Environment = ["PATH=${config.programs.eww.package}/bin:$PATH"];
    };
  };
}
