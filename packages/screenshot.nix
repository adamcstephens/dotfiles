{
  writeShellApplication,

  bash,
  grim,
  slurp,
  wl-clipboard-rs,
  xclip,
  xdotool,
}:

writeShellApplication {
  runtimeInputs = [
    bash
    grim
    slurp
    wl-clipboard-rs
    xclip
    xdotool
  ];

  text = builtins.readFile ./screenshot;
  name = "screenshot";
}
