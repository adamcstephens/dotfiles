{
  mkShellNoCC,

  python3,
}:

mkShellNoCC {
  packages = [
    (python3.withPackages (py: [
      py.black
      py.hexdump
      py.paramiko
    ]))
  ];
}
