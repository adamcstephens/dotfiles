{
  acpica-tools,
  bash,
  bc,
  coreutils,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  kernel,
  lib,
  pciutils,
  powertop,
  resholve,
  util-linux,
  xorg,
}:
resholve.mkDerivation {
  pname = "s0ix-selftest-tool";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "S0ixSelftestTool";
    rev = "1b6db3c3470a3a74b052cb728a544199661d18ec";
    hash = "sha256-w97jfdppW8kC8K8XvBntmkfntIctXDQCWmvug+H1hKA=";
  };

  patchPhase = ''
    rm turbostat
    substituteInPlace s0ix-selftest-tool.sh --replace '"$DIR"/turbostat' 'turbostat'
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    chmod +x s0ix-selftest-tool.sh
    cp s0ix-selftest-tool.sh $out/bin/s0ix-selftest-tool
  '';

  solutions = {
    default = {
      scripts = ["bin/s0ix-selftest-tool"];
      interpreter = "${lib.getExe bash}";
      inputs = [
        acpica-tools
        bc
        coreutils
        gawk
        gnugrep
        gnused
        kernel.turbostat
        pciutils
        powertop
        util-linux
        xorg.xset
      ];
      fake.external = ["dmesg" "sudo"];
      execer = [
        "cannot:${powertop}/bin/powertop"
        "cannot:${util-linux}/bin/rtcwake"
        "cannot:${kernel.turbostat}/bin/turbostat"
      ];
    };
  };

  buildInputs = [
    acpica-tools
    kernel.turbostat
  ];
}
