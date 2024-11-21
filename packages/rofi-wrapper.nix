{
  bash,
  lib,
  writeScriptBin,
}:
writeScriptBin "rofi-wrapper" # bash
  ''
    #!${lib.getExe bash}

    exec ${../bin/rofi-wrapper} $@
  ''
