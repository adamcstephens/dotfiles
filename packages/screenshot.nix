{
  lib,

  bash,
  xdotool,
  maim,
  slurp,
  grim,
  wl-clipboard-rs,
  xclip,
  writeShellScriptBin,
}:
writeShellScriptBin "screenshot" ''
  export PATH="${
    lib.makeBinPath [

      bash
      xdotool
      maim
      slurp
      grim
      wl-clipboard-rs
      xclip
    ]
  }

  exec ${./screenshot}
  "
''
