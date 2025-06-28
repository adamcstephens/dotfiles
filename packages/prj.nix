{
  bash,
  kitty,
  lib,
  python3,
  skim,
  tmux,
  writeScriptBin,
  zoxide,
}:
writeScriptBin "prj" ''
  #!${lib.getExe bash}
  export PATH="${
    lib.makeBinPath [
      kitty
      skim
      tmux
      zoxide
    ]
  }"
  ${lib.getExe python3} ${../bin/prj}
''
