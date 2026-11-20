{
  version,
  src,
  buildPackages,
}:

buildPackages.buildNpmPackage {
  pname = "finicky-ui";
  inherit version src;
  sourceRoot = "${src.name}/packages/finicky-ui";
  npmDepsHash = "sha256-TRbZ2YMvY8palWD7vImQhjbeVYKu4tsmctA/CIBGwhQ=";

  installPhase = ''
    runHook preInstall
    cp -r dist "$out"
    runHook postInstall
  '';
}
