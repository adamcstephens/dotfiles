{
  bash,
  kitty,
  fzf,
  lib,
  python3,
  tmux,
  writeScriptBin,
  zoxide,
}:
writeScriptBin "prj" ''
  #!${lib.getExe bash}
  export PATH="${
    lib.makeBinPath [
      fzf
      kitty
      tmux
      zoxide
    ]
  }"
  ${lib.getExe python3} ${../bin/prj}
''
