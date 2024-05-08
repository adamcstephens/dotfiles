{
  writeShellApplication,

  bash,
  grim,
  maim,
  slurp,
  wl-clipboard-rs,
  xclip,
  xdotool,
}:

writeShellApplication {
  runtimeInputs = [
    bash
    grim
    maim
    slurp
    wl-clipboard-rs
    xclip
    xdotool
  ];

  text = builtins.readFile ./screenshot;
  name = "screenshot";
}
