{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "toney";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "SourcewareLab";
    repo = "Toney";
    rev = "v${version}";
    hash = "sha256-lZcJE0q1c8wqk/dPln5m+32SiPWZHMHz8Ee+9SaCl4k=";
  };

  vendorHash = "sha256-4Ks6+VdDoXtIHgyMJwmEZWeNo6kDxKanXX3cuDhY+JQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Toney is a fast, lightweight, terminal-based note-taking app for the modern developer";
    homepage = "https://github.com/SourcewareLab/Toney";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "toney";
  };
}
