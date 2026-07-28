{ lib, pkgs, ... }:
let
  listenAddress = "10.3.2.52";

  tomlFormat = pkgs.formats.toml { };

  traefikDynamic = tomlFormat.generate "traefik-dynamic.toml" {
    http.routers.lmstudio = {
      rule = "Host(`lmstudio.svc.junco.dev`) || Host(`lmstudio.junco.dev`)";
      service = "lmstudio";
      entryPoints = [ "websecure" ];
      tls = {
        certResolver = "junco";
        domains = [
          { main = "lmstudio.svc.junco.dev"; }
        ];
        options = "mtls";
      };
    };

    http.services.lmstudio.loadBalancer.servers = [
      { url = "http://127.0.0.1:1234"; }
    ];

    tls.options = {
      mtls.clientAuth = {
        caFiles = [ ./root_ca.crt ];
        clientAuthType = "RequireAndVerifyClientCert";
      };
    };
  };

  traefikStatic = tomlFormat.generate "traefik-static.toml" {
    entryPoints.web.address = "${listenAddress}:18080";
    entryPoints.web.http.redirections.entryPoint = {
      to = "websecure";
      scheme = "https";
    };
    entryPoints.websecure.address = "${listenAddress}:18443";

    certificatesResolvers.junco.acme = {
      caServer = "https://cert.junco.dev/acme/acme/directory";
      storage = "/Users/adam/.local/share/traefik/acme.json";
      httpChallenge.entryPoint = "web";
    };

    providers.file = {
      filename = "${traefikDynamic}";
      watch = false;
    };
  };
in
{
  launchd.user.agents.traefik.serviceConfig = {
    ProgramArguments = [
      (
        pkgs.writeShellApplication {
          name = "traefik";
          runtimeInputs = [
            pkgs.traefik
          ];
          text = ''
            mkdir -p ~/.local/share/traefik
            traefik --configFile=${traefikStatic}
          '';
        }
        |> lib.getExe
      )
    ];
    KeepAlive = true;
    RunAtLoad = true;
    StandardErrorPath = "/Users/adam/Library/Logs/traefik.log";
    StandardOutPath = "/Users/adam/Library/Logs/traefik.log";
  };

  # required for the pf rdr above to reach traefik
  launchd.daemons.ip-forwarding.serviceConfig = {
    ProgramArguments = [
      "/usr/sbin/sysctl"
      "-w"
      "net.inet.ip.forwarding=1"
    ];
    RunAtLoad = true;
  };

  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
  };
  security.pf = {
    enable = true;
    rules = ''
      # junco traefik
      rdr pass inet proto tcp from any to ${listenAddress} port 80 -> ${listenAddress} port 18080
      rdr pass inet proto tcp from any to ${listenAddress} port 443 -> ${listenAddress} port 18443

      # bf traefik
      rdr pass on lo0 inet proto tcp from any to any port 80 -> (lo0) port 8000
      rdr pass on lo0 inet proto tcp from any to any port 443 -> (lo0) port 8443

      pass quick on lo0 no state

      # restrict ssh
      block return in proto tcp from any to any port ssh
      pass in inet proto tcp from any to ${listenAddress} port ssh

      pass in inet proto tcp from any to ${listenAddress} port {80, 443}
    '';
  };
}
