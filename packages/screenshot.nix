{
  bash,
  xdotool,
  maim,
  slurp,
  wayshot,
  wl-clipboard-rs,
  xclip,
  writeShellApplication,
}:

writeShellApplication {
  runtimeInputs = [
    bash
    xdotool
    maim
    slurp
    wayshot
    wl-clipboard-rs
    xclip
  ];

  text = builtins.readFile ./screenshot;
  name = "screenshot";
}
