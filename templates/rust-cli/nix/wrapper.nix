{
  installShellFiles,
  lib,
  myapp-unwrapped,
  makeWrapper,
  runCommand,
}:
runCommand "myapp"
  {
    nativeBuildInputs = [
      installShellFiles
      makeWrapper
    ];
    meta.mainProgram = "myapp";
  }
  ''
    mkdir -vp $out/bin/
    makeWrapper ${lib.getExe myapp-unwrapped} $out/bin/myapp --prefix PATH : ${
      lib.makeBinPath [
        # Add runtime tool dependencies here, e.g. pkgs.git
      ]
    }

    installShellCompletion --cmd myapp \
      --bash <(COMPLETE=bash $out/bin/myapp) \
      --fish <(COMPLETE=fish $out/bin/myapp) \
      --zsh <(COMPLETE=zsh $out/bin/myapp)
  ''
