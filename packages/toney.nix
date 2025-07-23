{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "toney";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "SourcewareLab";
    repo = "Toney";
    rev = "v${version}";
    hash = "sha256-y2j/WselGVLMVUcYfzCJeOySwo1o6W5flhdJvx/F2qk=";
  };

  vendorHash = "sha256-Ri9s9JZOAXFxw7/ffPitlfk/O7ccfv/t80QIwMbe/mE=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "Toney is a fast, lightweight, terminal-based note-taking app for the modern developer";
    homepage = "https://github.com/SourcewareLab/Toney";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "toney";
  };
}
