{
  mkShellNoCC,

  pkgs,
}:

mkShellNoCC {
  packages = [
    (pkgs.python3.withPackages (py: [
      py.black
      py.hexdump
      py.paramiko
    ]))

    pkgs.poetry
  ];
}
