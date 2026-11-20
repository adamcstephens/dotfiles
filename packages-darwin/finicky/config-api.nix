{
  version,
  src,
  buildPackages,
}:

buildPackages.buildNpmPackage {
  pname = "finicky-config-api";
  inherit version src;
  sourceRoot = "${src.name}/packages/config-api";
  npmDepsHash = "sha256-w5if926gtcq2LJW4uvvR9g5mAe1vgBzyxyeczHvmq6Y=";

  postBuild = ''
    npm run generate-types
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp dist/finickyConfigAPI.js dist/finicky.d.ts "$out/"
    runHook postInstall
  '';
}
