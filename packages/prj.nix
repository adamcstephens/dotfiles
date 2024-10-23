{
  bash,
  kitty,
  lib,
  python3,
  tmux,
  writeScriptBin,
  zf,
  zoxide,
}:
writeScriptBin "prj" ''
  #!${lib.getExe bash}
  export PATH="${
    lib.makeBinPath [
      kitty
      tmux
      zf
      zoxide
    ]
  }"
  ${lib.getExe python3} ${../bin/prj}
''
