{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "finicky";
  version = "4.4.0-alpha";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "johnste";
    repo = "finicky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EeT8lcwX6deShehr8sjpSxbBrzsmsFpT3BemnZKMq84=";
  };

  modRoot = "apps/finicky/src";

  vendorHash = "sha256-OMcQ2D8s5EmRrpHmTtjoLDbD97s+hB5bpCHyYTqKc2c=";

  configApi = callPackage ./config-api.nix { inherit (finalAttrs) src version; };
  ui = callPackage ./ui.nix { inherit (finalAttrs) src version; };

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    cp ${finalAttrs.configApi}/finickyConfigAPI.js assets/
    mkdir -p assets/templates
    cp -r ${finalAttrs.ui}/. assets/templates/
  '';

  postInstall = ''
    contents="$out/Applications/Finicky.app/Contents"
    mkdir -p "$contents/MacOS"
    mv "$out/bin/finicky" "$contents/MacOS/Finicky"
    cp -r ../assets/. "$contents/"
    cp ${finalAttrs.configApi}/finicky.d.ts "$contents/Resources/"
    makeWrapper "$contents/MacOS/Finicky" "$out/bin/finicky"
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=unstable"
        "--subpackage=configApi"
        "--subpackage=ui"
      ];
    };
  };

  meta = {
    description = "A macOS app for customizing which browser to start";
    homepage = "https://github.com/johnste/finicky";
    changelog = "https://github.com/johnste/finicky/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "finicky";
    platforms = lib.platforms.darwin;
  };
})
