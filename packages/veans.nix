{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "veans";
  version = "2.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "vikunja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qI4mkgcN9yYRmh5V+KzIHupX7uWsszV4Xb31OYvukxQ=";
  };

  modRoot = "veans";

  vendorHash = "sha256-4Ayug+r7sWL/JZI8fGCyDZ1SaTwCvSWrQpqv7uYCHhc=";

  ldflags = [ "-s" ];

  # needs a running vikunja instance
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The task manager you actually own";
    homepage = "https://github.com/go-vikunja/vikunja";
    changelog = "https://github.com/go-vikunja/vikunja/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vikunja";
  };
})
