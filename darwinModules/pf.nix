# https://gist.github.com/al3xtjames/ddecb984b8c8954dd9a112a697e756e3

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.security.pf;
  anchor = pkgs.writeText "nix" (
    ''
      #
      # pf rules managed by nix-darwin
      #

    ''
    + cfg.rules
  );
in
{
  options = {
    security.pf = {
      enable = lib.mkEnableOption "packet filtering with pf";
      rules = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Packet filtering rules for {manpage}`pf(4)`.
          See {manpage}`pf.conf(5)` for documentation.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # assertions = [
    #   {
    #     assertion =
    #       config.networking.applicationFirewall ? enable
    #       && config.networking.applicationFirewall.enable
    #       && config.networking.applicationFirewall.enableStealthMode;
    #     message = "both `networking.applicationFirewall.enable` and `networking.applicationFirewall` must be enabled";
    #   }
    # ];

    system.activationScripts.networking.text = ''
      pfctl -f /etc/pf.conf 1> /dev/null 2>&1
      pfctl -a com.apple/nix -F all 1> /dev/null
      pfctl -e -a com.apple/nix -f ${anchor} 1> /dev/null || true
    '';

    launchd.daemons.pf-loader = {
      serviceConfig = {
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/bin/wait4path /nix/store && /sbin/pfctl -f /etc/pf.conf && /sbin/pfctl -e -a com.apple/nix -f ${anchor}"
        ];

        RunAtLoad = true;
      };
    };
  };
}
